//
//  TagEditor.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/24/25.
//

import SwiftUI
import VisualDebugging

struct TagEditor: View {
    
    let tagInfo: TagInfo
    
    let convert: (TagInfo, TagInfo) -> Void
    let delete: (TagInfo) -> Void
    
    @State private var newName: String
    @State private var newColorHue: CGFloat
    
    @State private var showingDeleteAlert = false
    
    @Environment(\.colorScheme) var colorScheme

    private var newTagInfo: TagInfo {
        .init(name: newName, colorHue: newColorHue)
    }

    let hideNavigationBarTitle: Bool
    let flowButtonsInToolbar: Bool
    let showComparison: Bool

    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: Bool?

    init(tagInfo: TagInfo,
         hideNavigationBarTitle: Bool = true,
         flowButtonsInToolbar: Bool = true,
         showComparison: Bool = false,
         convert: @escaping (TagInfo, TagInfo) -> Void,
         delete: @escaping (TagInfo) -> Void
    ) {
        self.tagInfo = tagInfo
        self.newName = tagInfo.name
        self.newColorHue = tagInfo.colorHue
        
        self.hideNavigationBarTitle = hideNavigationBarTitle
        self.flowButtonsInToolbar = flowButtonsInToolbar
        self.showComparison = showComparison
        
        self.convert = convert
        self.delete = delete
    }
    
    var body: some View {
        NavigationStack {
            VStack {

                if !flowButtonsInToolbar {
                    Spacer()
                }
                
                if showComparison {

                    HStack {
                        Text("Original:")
                            .bold()

                        Text(tagInfo.name)
                            .modifier(BookmarkTagShaped(bookmarkedEdge: .leading, isExpanded: true, isPressed: false, maxContentWidth: 233, color: tagInfo.color(for: colorScheme)))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.leading)
                    .opacity(tagInfo == newTagInfo ? 0 : 1)
                    .accessibilityHidden(true)
                }

                
                HStack {
                    Text("New:")
                        .bold()
                        .accessibilityHidden(true)
                        .opacity(tagInfo == newTagInfo ? 0 : 1)

                    TextField("Tag Name", text: $newName)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .focused($focusedField, equals: true)
                        .textFieldStyle(.plain)
                        .modifier(BookmarkTagShaped(bookmarkedEdge: .leading, isExpanded: true, isPressed: false, maxContentWidth: 233, color: newTagInfo.color(for: colorScheme)))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .onAppear {
                            focusedField = true
                        }
                        .onSubmit(doneButtonTapped)
                        .submitLabel(.done)
                }
                .padding(.leading)

                
                HStack {
                    Text("Color:")
                        .bold()
                        .accessibilityHidden(true)
                    Slider(value: $newColorHue, in: 0 ... 1) {
                        Label("Color:", systemImage: "")
                    }
                    .accentColor(newTagInfo.color(for: colorScheme))
                    .padding()
                    .labelStyle(.titleOnly)
                }
                .padding(.horizontal)

                if !flowButtonsInToolbar {
                    Spacer()
                    Spacer()
                }
                
                VStack {
                    
                    Button(role: .destructive, action: deleteButtonTapepd) {
                        Label("Delete", systemImage: "trash")
                            .frame(maxWidth: .infinity)

                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .padding(.bottom)

                    if !flowButtonsInToolbar {
                        HStack {
                            Button( action: cancelButtonTapped) {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                            }
                            .keyboardShortcut(.cancelAction)
                            
                            Button(action: doneButtonTapped) {
                                Text("Done")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .keyboardShortcut(.defaultAction)
                            .disabled(tagInfo == newTagInfo || newName.isEmpty)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
            }
            .frame(minWidth: 377)
            .navigationTitle(hideNavigationBarTitle ? "" : "Edit Tag" + (showComparison ? "" : " \"\(tagInfo.name)\""))
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                if flowButtonsInToolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        cancelButton
                            .keyboardShortcut(.escape)
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        doneButton
                            .keyboardShortcut(.return)
                            .bold()
                    }
                }
            }
            .alert("Delete Tag \"\(tagInfo.name)\"", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteConfirmed()
                }
            } message: {
                Text("This will delete this tag and remove it from any bookmark that you've tagged with it.")
            }
        }

    }
    
    private var cancelButton: some View {
        Button(action: cancelButtonTapped) {
            Text("Cancel")
                .frame(maxWidth: .infinity)
        }
        .keyboardShortcut(.cancelAction)
    }
    
    private var doneButton: some View {
        Button(action: doneButtonTapped) {
            Text("Done")
                .frame(maxWidth: .infinity)
        }
    }
    
    private func deleteButtonTapepd() {
        showingDeleteAlert = true
    }

    private func deleteConfirmed() {
        delete(tagInfo)
        dismiss()
    }

    private func cancelButtonTapped() {
        dismiss()
    }
    
    private func doneButtonTapped() {
        convert(tagInfo, newTagInfo)
        dismiss()
    }
}

#if DEBUG

#Preview {
    TagEditor(tagInfo: TagInfo(name: "hello", colorHue: 195/360), showComparison: true) { _, _ in } delete: { _ in }
        .widerPreview()
}
#endif
