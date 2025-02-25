//
//  TagsEditor.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUI
import Observation
import VisualDebugging

extension EnvironmentValues {
    
    /// The current tags filter
    @Entry var tagsEditorSceneID = UUID()
}

extension Notification.Name {
    static var userTappedOutsideTagsEditor: Self { .init(rawValue: #function) }
}


struct TagsEditorScene: ViewModifier {
    
    let id: UUID
    
    init(id: UUID = UUID()) {
        self.id = id
    }

    func body(content: Content) -> some View {
        content
        // TODO: this causes problems in iOS
        // try to figure out a way to make it work
        #if os(macOS)
            .environment(\.tagsEditorSceneID, id)
            .onTapGesture {
                NotificationCenter.default.post(name: .userTappedOutsideTagsEditor, object: id)
            }
        #endif
    }
}

public extension View {
    func tagsEditorScene(id: UUID = UUID()) -> some View {
        modifier(TagsEditorScene(id: id))
    }
}

fileprivate struct TagsEditorSceneToggleListener: ViewModifier {
    
    let callback: () -> Void
    
    @Environment(\.tagsEditorSceneID) var tagsEditorSceneID

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .userTappedOutsideTagsEditor)) { notification in
                guard notification.object as? UUID == tagsEditorSceneID else { return }
                
                callback()
            }
    }
}

fileprivate extension View {
    func onOutsideTap(perform callback: @escaping () -> Void) -> some View {
        modifier(TagsEditorSceneToggleListener(callback: callback))
    }
}

struct TagEditorToggle<T: TagsSource> : View {
    
    let tag: TagInfo
    @ObservedObject var tags: T
    
    let tagEditorShouldShowTitle: Bool
    let tagEditorShouldShowFlowButtonsInToolbar: Bool
    let tagEditorShouldShowComparison: Bool

    let doubleTapAction: (TagInfo) -> Void

    @State private var showingPopover = false
    
    var body: some View {
        TagToggle(
            tag,
            .leading,
            isSelected: tags.selectedBinding(for: tag),
            buttonImageName: "info.circle",
            buttonTitle: "Edit Tag \(tag.name)",
            buttonAction: {
                showingPopover = true
            },
            // TODO: this doesn't seem to work in macOS
            // verify and decide if a workaround is needed
            doubleTapAction: {
                doubleTapAction(tag)
            }
        )
        .popover(isPresented: $showingPopover) {
            TagEditor(
                tagInfo: tag,
                hideNavigationBarTitle: !tagEditorShouldShowTitle,
                flowButtonsInToolbar: tagEditorShouldShowFlowButtonsInToolbar,
                showComparison: tagEditorShouldShowComparison,
                convert: { oldValue, newValue in
                    print("will replace \(oldValue) with \(newValue)")
                    try? self.tags.replace(tag, with: newValue)
                },
                delete: { tag in
                    try? tags.delete(tag)
                }
            )
            .presentationDetents([.medium])
        }

    }
}

public struct TagsEditor<T: TagsSource>: View {
    
    @ObservedObject var tags: T
    
    @State private var isEditing = false
    @State private var tagOpacity: CGFloat = 0
    @State private var editingTag: TagInfo?
    
    @Namespace private var animation
    
    #if canImport(UIKit)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    public init(tags: T) {
        self.tags = tags
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
            if isEditing {
                ForEach(tags.tags) { tag in
                    TagEditorToggle(tag: tag, tags: tags, tagEditorShouldShowTitle: tagEditorShouldShowTitle, tagEditorShouldShowFlowButtonsInToolbar: tagEditorShouldShowFlowButtonsInToolbar, tagEditorShouldShowComparison: tagEditorShouldShowComparison) {
                        selectAndDismissEditing($0)
                    }
                    .opacity(max(tags.selectedBinding(for: tag).wrappedValue ? 1 : 5/34, tagOpacity))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .matchedGeometryEffect(id: tag.id, in: animation)
                }
            }
            else {
                ForEach(tags.selected.tags) {tag in
                    TagDisplay(tag, .leading, action: beginEditing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .matchedGeometryEffect(id: tag.id, in: animation)
                }
            }
            
            if isEditing {
                AddTagButton(bookmarkedEdge: .leading) { try? tags.addTag(named:$0) }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .matchedGeometryEffect(id: "add", in: animation)
                    .opacity(tagOpacity)

                TitledTagButton("Done", .leading, action: finishEditing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .matchedGeometryEffect(id: "editing", in: animation)
                    .padding(.top)
            }
            else if tags.selected.isEmpty {
                TitledTagButton("Add Tags", .leading, action: beginEditing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .matchedGeometryEffect(id: "editing", in: animation)
            }
            
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut, value: isEditing)
        .animation(.easeInOut, value: tags.tags)
        .contentShape(Rectangle())
        .onTapGesture(perform: finishEditing)
        .onOutsideTap(perform: finishEditing)
    }
    
    private var tagEditorShouldShowComparison: Bool {
        #if os(macOS)
        false
        #else
        horizontalSizeClass == .compact
        #endif
    }
    
    private var tagEditorShouldShowTitle: Bool {
        #if os(macOS)
        true
        #else
        horizontalSizeClass == .compact
        #endif
    }

    private var tagEditorShouldShowFlowButtonsInToolbar: Bool {
        #if os(macOS)
        false // buttons don't show up in toolbar on macOS
        #else
        true
        #endif
    }

    private func beginEditing() {
        withAnimation {
            isEditing = true
        } completion: {
            withAnimation(.easeIn) {
                tagOpacity = 1
            }
        }
    }

    private func finishEditing() {
        guard isEditing else { return }
        withAnimation(.easeIn) {
            tagOpacity = 0
        } completion: {
            isEditing = false
        }
    }
    
    private func selectAndDismissEditing(_ tag: TagInfo) {
        try? tags.toggleSelection(for: tag)
        isEditing = false
    }
}

#if DEBUG

extension TagsEditor where T == ExampleTagsSource {
    static func forTesting(_ source: ExampleTagsSource = .empty) -> TagsEditor {
        TagsEditor(tags: source)
    }
}


#Preview("Empty") {
    ScrollView {
        TagsEditor.forTesting()
    }
    .frame(height: 400)
    .reasonablySizedPreview()
}

#Preview("Has A Few") {
    ScrollView {
        TagsEditor.forTesting(.hasAFew)
    }
    .frame(height: 400)
    .reasonablySizedPreview()
    .tagsEditorScene()
}
#endif
