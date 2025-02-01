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
            Label(tags.selected.tags.keyedLabelTitle, systemImage: "bookmark")
                .foregroundStyle(.secondary)
        case 1:
            let tag = tags.selected.tags[0]
            Label(tag.name, systemImage: "bookmark")
                .foregroundStyle(tag.color)
                .symbolVariant(.fill)

        default:
            Label {
                Text(tags.selected.tags.keyedLabelTitle)
                    .foregroundStyle(LinearGradient(colors: tags.selected.tags.map(\.color), startPoint: .leading, endPoint: .trailing))
            } icon: {
                // I can't show multiple bookmark iamges,
                // but I can show a gradient of their colors
                GradientColoredImage(systemImageName: "bookmark", colors: tags.selected.tags.map(\.color))
                    .symbolVariant(.fill)
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
