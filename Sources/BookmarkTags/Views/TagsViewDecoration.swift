//
//  TagsViewDecoration.swift
//  BookmarkTags
//
//  Created by Joseph Wardell on 2/26/25.
//

import SwiftUI

public struct TagsViewDecoration: View {
    
    let tags: [TagInfo]
    
    init(tags: [TagInfo]) {
        self.tags = tags
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    public var body: some View {
        LinearGradient(colors: tags.map { $0.color(for: colorScheme) }, startPoint: .leading, endPoint: .trailing)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .clear, location: 0.9),
                        .init(color: .white.opacity(5/34), location: 1),
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topLeading
                )
            )
    }
}

fileprivate extension TagInfo {
    static var exampleForPreviews: TagInfo { .init(name: #function, colorHue: 40/360) }
    static var exampleForPreviews2: TagInfo { .init(name: #function, colorHue: 120/360) }
    static var exampleForPreviews3: TagInfo { .init(name: #function, colorHue: 320/360) }
}

#Preview {
    TagsViewDecoration(tags: [.exampleForPreviews])
}

#Preview {
    TagsViewDecoration(tags: [.exampleForPreviews, .exampleForPreviews2])
}

#Preview {
    TagsViewDecoration(tags: [.exampleForPreviews, .exampleForPreviews2, .exampleForPreviews3])
}
