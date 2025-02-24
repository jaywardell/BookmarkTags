//
//  WeakTagsSource.swift
//  SkyMark Shared Views
//
//  Created by Joseph Wardell on 1/27/25.
//

import SwiftUICore

/// a dummy TagsSource that keeps a list of tags in memory
/// this is just an example of how a TagsSource type could be implemented
final class WeakTagsSource: ObservableObject {
    @Published var tags: [TagInfo]
    @Published var selected: TagsCursor
    
    init(tags: [TagInfo] = []) {
        self.tags = tags
        self.selected = .empty
    }
}

extension WeakTagsSource: TagsSource {
    
    func toggleSelection(for tag: TagInfo) throws {
        if selected.contains(tag) {
            selected = selected.removing(tag)
        }
        else {
            selected = selected.adding(tag)
        }
    }
    
    func deselectAll() {
        selected = .empty
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
