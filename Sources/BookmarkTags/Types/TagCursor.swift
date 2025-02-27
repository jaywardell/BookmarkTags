//
//  File.swift
//  BookmarkTags
//
//  Created by Joseph Wardell on 1/28/25.
//

import SwiftUICore

public struct TagsCursor {
    public let tags: [TagInfo]
    
    public var isEmpty: Bool { tags.isEmpty }
    
    private init(tags: [TagInfo]) {
        self.tags = tags
    }
    
    public func contains(_ tag: TagInfo) -> Bool {
        tags.contains(tag)
    }
    
    public static var empty: TagsCursor {
        .init(tags: [])
    }
    
    public func adding(_ tag: TagInfo) -> Self {
        guard !tags.contains(tag) else { return self }
        
        return .init(tags: tags + [tag])
    }
    
    public func removing(_ tag: TagInfo) -> Self {
        var newTags = tags
        if let index = tags.firstIndex(where: { $0 == tag }) {
            newTags.remove(at: index)
        }
        return .init(tags: newTags)
    }
}

//extension TagsCursor {
//    var keyedLabelTitle: LocalizedStringKey {
//        switch tags.count {
//        case 0: "No Tags"
//            // see https://nilcoalescing.com/blog/HandlePluralsInSwiftUITextViewsWithInflection/
//        default: "^[\(tags.count) tag](inflect: true)"
//        }
//    }
//}

extension Array where Element == TagInfo {
    func keyedLabelTitle(for predicateType: TagsPredicateType? = nil) -> LocalizedStringKey {

        switch count {
        case 0: "Any Tags"
            // see https://nilcoalescing.com/blog/HandlePluralsInSwiftUITextViewsWithInflection/
            // TODO: for english, use "Either of" for 2 choices
        default: "\(predicateType == .anyTag ? "Any of " : "")^[\(count) Tag](inflect: true)"
        }
    }
}
