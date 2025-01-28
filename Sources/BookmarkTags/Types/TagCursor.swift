//
//  File.swift
//  BookmarkTags
//
//  Created by Joseph Wardell on 1/28/25.
//

import SwiftUICore

public struct TagsCursor {
    let tags: [TagInfo]
    
    var isEmpty: Bool { tags.isEmpty }
    
    private init(tags: [TagInfo]) {
        self.tags = tags
    }
    
    func contains(_ tag: TagInfo) -> Bool {
        tags.contains(tag)
    }
    
    public static var empty: TagsCursor {
        .init(tags: [])
    }
    
    func adding(_ tag: TagInfo) -> Self {
        guard !tags.contains(tag) else { return self }
        
        return .init(tags: tags + [tag])
    }
    
    func removing(_ tag: TagInfo) -> Self {
        var newTags = tags
        if let index = tags.firstIndex(where: { $0 == tag }) {
            newTags.remove(at: index)
        }
        return .init(tags: newTags)
    }
}

extension TagsCursor {
    var keyedLabelTitle: LocalizedStringKey {
        switch tags.count {
        case 0: "No Tags"
            // see https://nilcoalescing.com/blog/HandlePluralsInSwiftUITextViewsWithInflection/
        default: "^[\(tags.count) tag](inflect: true)"
        }
    }
}
