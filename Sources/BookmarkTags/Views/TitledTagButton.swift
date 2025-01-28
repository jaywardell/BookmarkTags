//
//  TitledTagButton.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/24/25.
//

import SwiftUI

/// A button that has a title and calls an action when pressed
/// that's in the style of a BookmarkTag
struct TitledTagButton: View {
    
    let title: LocalizedStringKey
    let bookmarkedEdge: BookmarkTagShaped.IndentedEdge

    let action: () -> Void
    
    init(
        _ title: LocalizedStringKey,
        _ bookmarkedEdge: BookmarkTagShaped.IndentedEdge,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.bookmarkedEdge = bookmarkedEdge
        self.action = action
    }
    
    private var titlePadding: Edge.Set {
        switch bookmarkedEdge {
        case .leading: .trailing
        case .trailing: .leading
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if bookmarkedEdge == .leading {
                    Spacer()
                }
                
                Text(title)
                    .padding(titlePadding)
                
                if bookmarkedEdge == .trailing {
                    Spacer()
                }
            }
        }
        .buttonStyle(BookmarkButtonStyle(isExpanded: true, bookmarkedEdge: bookmarkedEdge, color: .accentColor))
    }
}

#Preview {
    VStack {
        Spacer()

        TitledTagButton("tags",  .leading) { print("hi") }
            .frame(maxWidth: .infinity, alignment: .trailing)

        TitledTagButton("done", .trailing) { print("hi") }
            .frame(maxWidth: .infinity, alignment: .leading)

        Spacer()
        Spacer()
    }
}
