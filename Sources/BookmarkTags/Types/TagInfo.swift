//
//  TagInfo.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/23/25.
//

import SwiftUI

public struct TagInfo {
    public let name: String
    public let colorHue: CGFloat
    
    public init(name: String, colorHue: CGFloat) {
        self.name = name
        self.colorHue = colorHue
    }
    
    func color(for colorScheme: ColorScheme) -> Color {
        // using HSL color space
        // so that all tags are more or less the same color temperature
        // TODO: HSI could give more consistent brightness of colors
        // TODO: these look like ass in macOS dark mode, haven't tested in light mode
        Color(hue: colorHue, saturation: 29/34, lightness: 13/34)
    }

}

extension TagInfo: Equatable {}
extension TagInfo: Hashable {}
extension TagInfo: Sendable {}
extension TagInfo: Identifiable {
    public var id: String { name + String(Double(colorHue)) }
}
