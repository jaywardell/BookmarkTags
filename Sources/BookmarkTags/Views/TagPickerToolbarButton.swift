//
//  TagPickerToolbarButton.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/25/25.
//

import SwiftUI

public struct TagPickerToolbarButton<T: TagsSource>: View {
    
    @ObservedObject var tags: T

    @Binding private var predicateType: TagsPredicateType
    @State private var showingPopover = false
    
    public init(
        tags: T,
        predicateType: Binding<TagsPredicateType>
    ) {
        self.tags = tags
        self._predicateType = predicateType
    }
                
    @ViewBuilder
    var label: some View {
        
        switch tags.selected.tags.count {
        case 0:
            Label(tags.selected.keyedLabelTitle, systemImage: "bookmark")
                .foregroundStyle(.secondary)
        case 1:
            let tag = tags.selected.tags[0]
            Label(tag.name, systemImage: "bookmark")
                .foregroundStyle(tag.color)
        default:
            Label {
                Text(tags.selected.keyedLabelTitle)
            } icon: {
                // TODO: somehow present multiple bookmark icons
                // but iOS doesn't seem to want to let me
                // do that in the toolbar
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(tags.selected.tags[0].color)
            }
        }
    }
    
    private var navtitle: String { "Filter by Tag" }
    public var body: some View {
        ZStack {
            label
        }
        // it would be nice to use a Button here,
        // but the toolbar doesn't respect our labelstyle
        // if it's a Button
        .onTapGesture(perform: showPicker)
        .popover(isPresented: $showingPopover) {
            NavigationStack {
                TagsPickerList(tags: tags, predicateType: $predicateType)
                #if canImport(UIKit)
                    .navigationBarTitle(navtitle, displayMode: .inline)
                #elseif canImport(AppKit)
                    .navigationTitle(navtitle)
                #endif
            }
        }
    }
    
    private func showPicker() {
        showingPopover = true
    }
}

#Preview("Has a Few") {
    @Previewable @State var predicate: TagsPredicateType = .allTags
    
    NavigationStack {
        Text("Hello")
            .toolbar {
                TagPickerToolbarButton(tags: ExampleTagsSource.hasAFew, predicateType: $predicate)
                    .labelStyle(.titleAndIcon)
            }
    }
    .frame(width: 400, height: 200)
}
