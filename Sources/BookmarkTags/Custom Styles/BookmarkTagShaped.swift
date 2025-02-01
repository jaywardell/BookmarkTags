//
//  BookmarkTagShaped.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/24/25.
//

import SwiftUI

struct BookmarkTagShaped: ViewModifier {
        
    enum IndentedEdge { case leading, trailing }

    let bookmarkedEdge: IndentedEdge
    let isExpanded: Bool
    let isPressed: Bool
    let color: Color
    let fullsize: Bool
    
    let minContentWidth: CGFloat
    let maxContentWidth: CGFloat

    init(
        bookmarkedEdge: IndentedEdge,
        isExpanded: Bool,
        isPressed: Bool,
        minContentWidth: CGFloat = Self.minContentWidth,
        maxContentWidth: CGFloat = Self.maxContentWidth,
        fullsize: Bool = false,
        color: Color
    ) {
        self.bookmarkedEdge = bookmarkedEdge
        self.isExpanded = isExpanded
        self.isPressed = isPressed
        self.color = color
        self.fullsize = fullsize
        self.minContentWidth = minContentWidth
        self.maxContentWidth = maxContentWidth
    }
    
    private var contentAlignment: Alignment {
        switch bookmarkedEdge {
        case .leading:
                .trailing
        case .trailing:
                .leading
        }
    }
    private var font: Font { fullsize ? .body : .footnote }
    private static var minContentWidth: CGFloat { 55 }
    private static var maxContentWidth: CGFloat { 144 }
    private var contentWidth: CGFloat {
        isExpanded ? maxContentWidth : minContentWidth
    }
    @ScaledMetric private var smallIndent: CGFloat = 13
    @ScaledMetric private var fullsizeIndent: CGFloat = 21
    private var indent: CGFloat { fullsize ? fullsizeIndent : smallIndent }
    @ScaledMetric private var smallTagHeight: CGFloat = 21
    @ScaledMetric private var fullsizeTagHeight: CGFloat = 34
    private var tagHeight: CGFloat { fullsize ? fullsizeTagHeight : smallTagHeight }

    @ScaledMetric private var smallControlHeight: CGFloat = 34
    @ScaledMetric private var fullsizeControlHeight: CGFloat = 55
    private var controlHeight: CGFloat { fullsize ? fullsizeControlHeight : smallControlHeight }

    private func fillColor(_ isPressed: Bool) -> Color {
        isPressed ? color.opacity(21/34) : color.opacity(3/34)
    }
    
    private func pressedExtra() -> CGFloat {
        isPressed ? 34 : 0
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .frame(minWidth: minContentWidth + pressedExtra(),
                   idealWidth: contentWidth + pressedExtra(),
                   maxWidth: maxContentWidth)
            .frame(height: tagHeight)
            .frame(alignment: contentAlignment)
            .padding(.horizontal)
            .background(fillColor(isPressed), in: BookmarkFillShape(indentedEdge: bookmarkedEdge, indent: indent))
            .overlay {
                BookmarkStrokeShape(indentedEdge: bookmarkedEdge, indent: indent)
                    .stroke(color)
            }
            .foregroundStyle(isPressed ? .highlightedTagTextColor : color)
            .frame(minHeight: controlHeight)
    }
    
    private struct BookmarkFillShape: Shape {
                
        let indentedEdge: IndentedEdge
        let indent: CGFloat
        
        nonisolated func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let leadingIndent = indentedEdge == .leading ? indent : 0
            let trailingIndent = indentedEdge == .trailing ? indent : 0

            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            // bookmark should extend indent distance beyond its bounding rectangle
            path.addLine(to: CGPoint(x: rect.maxX + trailingIndent, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.maxX + trailingIndent, y: rect.maxY))
         
            path.addLine(to: CGPoint(x: rect.minX - leadingIndent, y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.minX - leadingIndent, y: rect.minY))

            path.closeSubpath()
            
            return path
        }
    }

    private struct BookmarkStrokeShape: Shape {
                
        let indentedEdge: IndentedEdge
        let indent: CGFloat
        
        nonisolated func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let leadingIndent = indentedEdge == .leading ? indent : 0
            let trailingIndent = indentedEdge == .trailing ? indent : 0

            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            // bookmark should extend indent distance beyond its bounding rectangle
            path.addLine(to: CGPoint(x: rect.maxX + trailingIndent, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.maxX + trailingIndent, y: rect.maxY))
         
            path.addLine(to: CGPoint(x: rect.minX - leadingIndent, y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.minX - leadingIndent, y: rect.minY))

            path.closeSubpath()
            
            return path
        }
    }

}

// MARK: -

fileprivate extension Color {
    static var highlightedTagTextColor: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .textBackgroundColor)
        #endif
    }
}

