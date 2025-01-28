//
//  BookmarkButtonStyle.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/21/25.
//

import SwiftUI

struct BookmarkButtonStyle: ButtonStyle {
    
    let isExpanded: Bool
    let bookmarkedEdge: BookmarkTagShaped.IndentedEdge
    let color: Color
    
    private var contentAlignment: Alignment {
        switch bookmarkedEdge {
        case .leading:
                .trailing
        case .trailing:
                .leading
        }
    }
        
    private var minContentWidth: CGFloat { 55 }
    private var maxContentWidth: CGFloat { 144 }
    private var contentWidth: CGFloat {
        isExpanded ? 144 : 55
    }
    private var indent: CGFloat { 21 }
    private var tagHeight: CGFloat { 34 }
    private var controlHeight: CGFloat { 55 }

    private func fillColor(_ isPressed: Bool) -> Color {
        isPressed ? color.opacity(13/34) : color.opacity(3/34)
    }
    
    private func pressedExtra(for configuration: Configuration) -> CGFloat {
        configuration.isPressed ? 34 : 0
    }
    

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .modifier(BookmarkTagShaped(bookmarkedEdge: bookmarkedEdge, isExpanded: isExpanded, isPressed: configuration.isPressed, color: color))
    }
    

}

