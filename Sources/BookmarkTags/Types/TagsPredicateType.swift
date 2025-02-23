//
//  TagsPredicateType.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUICore

public enum TagsPredicateType: CaseIterable, Identifiable {
    case allTags
    case anyTag
    
    public var id: TagsPredicateType { self }
    
    var displayName: LocalizedStringKey {
        switch self {
        case .allTags: "All"
        case .anyTag: "Any"
        }
    }
}
