//
//  TagsEditor.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUI
import Observation
import VisualDebugging


public struct TagsEditor<T: TagsSource>: View {
    
    @ObservedObject var tags: T
    
    @State private var isEditing = false
    @State private var tagOpacity: CGFloat = 0
    @State private var editingTag: TagInfo?
    
    @Namespace private var animation
    
    public init(tags: T) {
        self.tags = tags
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
            if isEditing {
                ForEach(tags.tags) { tag in
                    TagToggle(
                        tag,
                        .leading,
                        isSelected: tags.selectedBinding(for: tag),
                        buttonImageName: "info.circle",
                        buttonTitle: "Edit Tag \(tag.name)",
                        buttonAction: {
                            editingTag = tag
                        },
                        // TODO: this doesn't seem to work in macOS
                        // verify and decide if a workaround is needed
                        doubleTapAction: {
                            selectAndDismissEditing(tag)
                        }
                    )
                    .opacity(max(tags.selectedBinding(for: tag).wrappedValue ? 1 : 0, tagOpacity))
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
        .popover(item: $editingTag) { tagInfo in
            TagEditor(
                tagInfo: tagInfo,
                hideNavigationBarTitle: true,
                flowButtonsInToolbar: false,
                showComparison: true,
                convert: { oldValue, newValue in
                    print("will replace \(oldValue) with \(newValue)")
                    try? self.tags.replace(tagInfo, with: newValue)
                },
                delete: { tag in
                    try? tags.delete(tag)
                }
            )
            .presentationDetents([.medium])
        }
        
    }
    
    private func beginEditing() {
        withAnimation {
            isEditing = true
        } completion: {
            withAnimation {
                tagOpacity = 1
            }
        }
    }

    private func finishEditing() {
        withAnimation {
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
}
#endif
