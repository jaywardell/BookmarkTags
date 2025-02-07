//
//  AddTagView.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/21/25.
//

import SwiftUI
import VisualDebugging

/// Presents the user with a way to create a new tag.
/// User presses the tag area and a textfield appears where a name for a new tag can be entered
struct AddTagButton: View {
    
    let bookmarkedEdge: BookmarkTagShaped.IndentedEdge
    
    let action: (String) -> Void
    
    @State private var isEditing = false
    @State private var newTagName = ""
    @FocusState var focused: Bool?

    @Namespace private var animation
    
    static let color = Color(hue: 0, saturation: 0, brightness: 21/34)
    
    var body: some View {
        Button(action: startEditing) {
            Image(systemName: "plus")
                .imageScale(.large)
                .matchedGeometryEffect(id: "plus", in: animation)
        }
        .onChange(of: focused) { _, newValue in
            if true != newValue {
                cancelEditing()
            }
        }
        .opacity(isEditing ? 0 : 1)
        .buttonStyle(BookmarkButtonStyle(isExpanded: true, bookmarkedEdge: bookmarkedEdge, color: Self.color))
        .overlay {
            if isEditing {
                HStack {
                    Button("Add Tag Named \(newTagName)", systemImage: "plus", action: addTag)
                        .buttonStyle(.borderless)
                        .disabled(newTagName.isEmpty)
                        .matchedGeometryEffect(id: "plus", in: animation)
                    
                    TextField("New Tag Name", text: $newTagName)
                        .textFieldStyle(.plain)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .focused($focused, equals: true)
                        .onSubmit(addTag)
                        .submitLabel(.done)

                    
                    Button("Cancel", systemImage: "xmark", action: cancelEditing)
                        .buttonStyle(.borderless)
                        .keyboardShortcut(.cancelAction)
                }
                .labelStyle(.iconOnly)
                .modifier(BookmarkTagShaped(bookmarkedEdge: bookmarkedEdge, isExpanded: true, isPressed: false, color: Self.color))
            }
        }
    }
    
    private func startEditing() {
        guard !isEditing else { return }
        withAnimation {
            isEditing = true
        }
        Task.detached {
            // Delay the task by 1 second:
            try await Task.sleep(nanoseconds: 5_000)
            await MainActor.run {
                focused = true
            }
        }
    }
    
    private func cancelEditing() {
        isEditing = false
        newTagName = ""
    }

    private func addTag() {
        if !newTagName.isEmpty {
            action(newTagName)
        }
        
        cancelEditing()
    }
}


#if DEBUG
#Preview {
    VStack {
        Spacer()

        AddTagButton(bookmarkedEdge: .leading) { print($0) }
            .frame(maxWidth: .infinity, alignment: .trailing)

        AddTagButton(bookmarkedEdge: .trailing) { print($0) }
            .frame(maxWidth: .infinity, alignment: .leading)

        Spacer()
        
        AddTagButton(bookmarkedEdge: .leading) { print($0) }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        
        AddTagButton(bookmarkedEdge: .trailing) { print($0) }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

        Spacer()
    }
    .reasonablySizedPreview()
}
#endif
