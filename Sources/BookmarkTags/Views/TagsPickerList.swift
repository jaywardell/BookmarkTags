//
//  TagsPickerList.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUI

struct TagsPickerList<T: TagsSource>: View {
    
    let maxTags: MaxTagsCount
    
    @ObservedObject var tags: T
    
    @Binding private var predicateType: TagsPredicateType
    
    @Environment(\.dismiss) var dismiss
    
    init(tags: T,
         count: MaxTagsCount,
         predicateType: Binding<TagsPredicateType>) {
        self.tags = tags
        self._predicateType = predicateType
        self.maxTags = count
    }
    
    private var shouldShowDeselectAllButton: Bool {
        tags.selected.tags.count > 1
    }
    
    private var deselectallButton: some View {
        Button("Deslect All") {
            tags.deselectAll()
        }
    }
    
    var body: some View {
        
        VStack {
            ScrollView {
                
                if case .many = maxTags {
                    VStack(alignment: .leading) {
                        // I don't think I want this explaantory text,
                        // but I'll leave it here just in case for now
    //                    HStack {
    //                        Text("Match")
                            Picker("Type of Search", selection: $predicateType) {
                                ForEach(TagsPredicateType.allCases) { type in
                                    Text(type.displayName)
                                }
                            }
                            .pickerStyle(.segmented)
                            Spacer()
    //                    }
    //                    .padding(.horizontal)
    //                    Text("bookmarks with the tags")
                    }
                    .font(.headline)
                    .padding()
    //                .padding(.bottom)
    //                .padding(.horizontal)
                    .opacity(tags.selected.tags.count > 1 ? 1 : 0)
                    .frame(maxHeight: tags.selected.tags.count > 1 ? nil : 0)
                }

                ForEach(tags.tags) { tag in
                    TagToggle(
                        tag,
                        .trailing,
                        isSelected: tags.selectedBinding(for: tag),
                        fullsize: true,
                        doubleTapAction: {
                            try? tags.toggleSelection(for: tag)
                            dismiss()
                        })
                    .onChange(of: tags.selectedBinding(for: tag).wrappedValue) { oldValue, newValue in
                        guard case .one = maxTags else { return }
                        
                        if newValue {
                            deselectAll(except: tag)
                        }
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            #if os(macOS)
            // on macOS, the toolbar button apparently won't appear
            // in the toolbar of a popover
            // so it needs to be placed here instead
            if shouldShowDeselectAllButton {
                deselectallButton
                    .padding(.bottom)
                    .padding(.trailing)
                    .containerRelativeFrame([.horizontal], alignment: .trailing)
                    .buttonStyle(.borderless)
                    .controlSize(.small)
            }
            #endif
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction){
                Button("Done") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                deselectallButton
                    .disabled(!shouldShowDeselectAllButton)
            }
        }
        .animation(.easeInOut, value: tags.selected.tags)
    }
    
    private func deselectAll(except toSelect: TagInfo) {
        for tag in tags.selected.tags {
            guard tag != toSelect else { continue }
            try? tags.toggleSelection(for: tag)
        }
    }
}

#if DEBUG

#Preview("Select Many") {
    
    @Previewable @State var predicateType: TagsPredicateType = .allTags
    
    NavigationStack {
        TagsPickerList(tags: ExampleTagsSource.hasAFew,
                       count: .many,
                       predicateType: $predicateType)
    }
    .reasonablySizedPreview()
}

#Preview("Select One") {
    
    @Previewable @State var predicateType: TagsPredicateType = .allTags
    
    NavigationStack {
        TagsPickerList(tags: ExampleTagsSource.hasAFew,
                       count: .one,
                       predicateType: $predicateType)
    }
    .reasonablySizedPreview()
}
#endif
