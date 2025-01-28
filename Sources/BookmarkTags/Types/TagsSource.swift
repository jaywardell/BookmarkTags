//
//  TagsSource.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUICore

@MainActor
public protocol TagsSource: ObservableObject {

    var tags: [TagInfo] { get }
    var selected: TagsCursor { get }
    
    func toggleSelection(for tag: TagInfo) throws
    func selectedBinding(for tag: TagInfo) -> Binding<Bool>
    
    func addTag(named tag: String) throws
    func delete(_ tag: TagInfo) throws
    
    func replace(_ toReplace: TagInfo, with replacement: TagInfo) throws
}

extension TagsSource {
    var isEmpty: Bool { tags.isEmpty }
    var count: Int { tags.count }
}

// MARK: -

#if DEBUG

final class ExampleTagsSource: ObservableObject {
    @Published var tags: [TagInfo]
    @Published var selected: TagsCursor
    
    init(tags: [TagInfo]) {
        self.tags = tags
        self.selected = .empty
    }
}

extension ExampleTagsSource: TagsSource {
    
    func toggleSelection(for tag: TagInfo) throws {
        if selected.contains(tag) {
            selected = selected.removing(tag)
        }
        else {
            selected = selected.adding(tag)
        }
    }
    
    func addTag(named name: String) throws {
        let tag = TagInfo(name: name, colorHue: .random(in: 0 ... 1))
        tags.append(tag)
        selected = selected.adding(tag)
    }
    
    func delete(_ tag: TagInfo) throws {
        selected = selected.removing(tag)
        tags.removeAll { $0 == tag }
    }
    
    func replace(_ toReplace: TagInfo, with replacement: TagInfo) throws {
        
        guard let index = tags.firstIndex(of: toReplace) else { return }
        
        let selectReplacement = selected.contains(toReplace)
        selected = selected.removing(toReplace)

        tags[index] = replacement
        if selectReplacement {
            selected = selected.adding(replacement)
        }
    }
    
    func selectedBinding(for tag: TagInfo) -> Binding<Bool> {
        Binding { [weak self] in
            true == self?.selected.contains(tag)
        } set: { [weak self] adding in
            guard let self else { return }
            if adding {
                selected = selected.adding(tag)
            }
            else {
                selected = selected.removing(tag)
            }
        }

    }

}

extension ExampleTagsSource {
    static var empty: ExampleTagsSource {
        .init(tags: [])
    }
    
    static var hasOne: ExampleTagsSource {
        .init(tags: [
            TagInfo(name: "programming", colorHue: 0)
        ])
    }

    static var hasTwo: ExampleTagsSource {
        .init(tags: [
            TagInfo(name: "programming", colorHue: 0),
            TagInfo(name: "exercise", colorHue: 120/360)
        ])
    }

    static var hasThree: ExampleTagsSource {
        .init(tags: [
            TagInfo(name: "programming", colorHue: 0),
            TagInfo(name: "exercise", colorHue: 120/360),
            TagInfo(name: "work", colorHue: 240/360),
        ])
    }
    
    static var hasAFew: ExampleTagsSource {
        .init(tags: [
            TagInfo(name: "programming", colorHue: 0),
            TagInfo(name: "exercise", colorHue: 120/360),
            TagInfo(name: "work", colorHue: 240/360),
            TagInfo(name: "free time", colorHue: 180/360)
        ])
    }
    
    static var examples: [ExampleTagsSource] {
        [
            empty,
            hasOne,
            hasTwo,
            hasThree,
            hasAFew
        ]
    }
}


#endif
