//
//  TagDisplay.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/21/25.
//

import SwiftUI

/// Presents a tag that the user has applied to a bookmark.
/// If user presses the tag, an action is called (probably to present the UI for choosing tags)
struct TagDisplay: View {
    
    let viewModel: TagInfo
    let bookmarkEdge: BookmarkTagShaped.IndentedEdge
    
    let action: () -> Void
        
    init(
        _ viewModel: TagInfo,
        _ bookmarkEdge: BookmarkTagShaped.IndentedEdge,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.bookmarkEdge = bookmarkEdge
        self.action = action
    }
    
    var body: some View {
        Button(viewModel.name, action: action)
            .buttonStyle(BookmarkButtonStyle(isExpanded: true, bookmarkedEdge: bookmarkEdge, color: viewModel.color))
    }
}

#Preview {
        
    VStack {
        TagDisplay(.init(name: "example", colorHue: 200/360), .leading) {}
            .frame(maxWidth: .infinity, alignment: .trailing)

        TagDisplay(.init(name: "example 2", colorHue: 250/360), .leading) {}
            .frame(maxWidth: .infinity, alignment: .trailing)

        TagDisplay(.init(name: "a longer tag name", colorHue: 300/360), .leading) {}
            .frame(maxWidth: .infinity, alignment: .trailing)

        TagDisplay(.init(name: "a longer tag name", colorHue: 350/360), .trailing) {}
            .frame(maxWidth: .infinity, alignment: .leading)

        TagDisplay(.init(name: "a longer tag name", colorHue: 40/360), .trailing) {}
            .frame(maxWidth: .infinity, alignment: .leading)

        TagDisplay(.init(name: "a much much much longer tag name, I mean it's ridiculous how long this name is", colorHue: 40/360), .trailing) {}
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    .reasonablySizedPreview()
}
