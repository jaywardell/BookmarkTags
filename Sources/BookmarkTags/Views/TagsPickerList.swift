//
//  TagsPickerList.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUI

struct TagsPickerList<T: TagsSource>: View {
    
    
    @ObservedObject var tags: T
    
    @Binding private var predicateType: TagsPredicateType
    
    @Environment(\.dismiss) var dismiss
    
    init(tags: T, predicateType: Binding<TagsPredicateType>) {
        self.tags = tags
        self._predicateType = predicateType
    }
    
    var body: some View {
        
        ScrollView {
            
            HStack {
                Text("Bookmarks matching:")
                Picker("Type of Search", selection: $predicateType) {
                    ForEach(TagsPredicateType.allCases) { type in
                        Text(type.displayName)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            ForEach(tags.tags) { tag in
                TagToggle(
                    tag,
                    .trailing,
                    isSelected: tags.selectedBinding(for: tag),
                    fullsize: true)
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
    }
}

struct ExampleTagsPickerListUI: View {
    
    let tags = ExampleTagsSource.hasAFew
    
    @State private var predicateType: TagsPredicateType = .allTags
    
    var body: some View {
        TagsPickerList(tags: tags, predicateType: $predicateType)

    }
}

#Preview {
    NavigationStack {
        ExampleTagsPickerListUI()
    }
}
