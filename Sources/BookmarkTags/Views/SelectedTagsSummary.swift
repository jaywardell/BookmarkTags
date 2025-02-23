//
//  SelectedTagsSummary.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/26/25.
//

import SwiftUI

struct SelectedTagsSummary: View {
    
    let tags: [TagInfo]
    let predicate: TagsPredicateType

    private var bookmarkName: String { "bookmark" }

    @Environment(\.colorScheme) var colorScheme
    
    private var gradientBookmark: some View {
        GradientColoredImage(systemImageName: bookmarkName, colors: tags.map { $0.color(for: colorScheme) })
            .symbolVariant(.fill)
    }
    
    private var stackedBookmarks: some View {
        HStack(spacing: -13) {
            ForEach(0 ..< tags.count, id: \.self) { index in
                let tag = tags[index]
                Image(systemName: bookmarkName)
                    .foregroundStyle(tag.color(for: colorScheme))
                    .symbolVariant(.fill)
                    .zIndex(Double(-index))
            }
        }
    }

    private var sideBySideBookmarks: some View {
        HStack(spacing: 0) {
            
            ForEach(0 ..< tags.count, id: \.self) { index in
                let tag = tags[index]
                Image(systemName: bookmarkName)
                    .foregroundStyle(tag.color(for: colorScheme))
                    .symbolVariant(.fill)
            }
        }
    }
    
    @ViewBuilder
    var shortest: some View {
        switch tags.count {
        case 0:
            Image(systemName: bookmarkName)
                .foregroundStyle(.secondary)

        default:
            gradientBookmark
        }
    }

    
    @ViewBuilder
    var shorter: some View {
        switch tags.count {
        case 0:
            Image(systemName: bookmarkName)
                .foregroundStyle(.secondary)

        default:
            sideBySideBookmarks
        }
    }

    @ViewBuilder
    var short: some View {
        switch tags.count {
        case 0:
            Label(tags.keyedLabelTitle(), systemImage: bookmarkName)
                .foregroundStyle(.secondary)
        case 1:
            Label(tags[0].name, systemImage: bookmarkName)
                .foregroundStyle(tags[0].color(for: colorScheme))
                .symbolVariant(.fill)
        default:
            
            Label {
                // TODO: pass in predicateType
                Text(tags.keyedLabelTitle(for: predicate))
                    .foregroundStyle(LinearGradient(colors: tags.map { $0.color(for: colorScheme) }, startPoint: .leading, endPoint: .trailing))
            } icon: {
                stackedBookmarks
            }
        }
    }
    
    @ViewBuilder
    var long: some View {
        switch tags.count {
        case 0, 1:
            short
        default:
            
            HStack {
                ForEach(0 ..< tags.count, id: \.self) { index in
                    let tag = tags[index]
                    
                    concaterator(index, in: tags.count)

                    Text(labelName(for: tag, at: index, of: tags.count))
                        .foregroundStyle(tag.color(for: colorScheme))
                        .symbolVariant(.fill)
                }
            }
            .lineLimit(1)
            .multilineTextAlignment(.leading)
        }
    }

    @ViewBuilder
    var longer: some View {
        switch tags.count {
        case 0, 1:
            short
        default:
            
            Label {
                HStack {
                    ForEach(0 ..< tags.count, id: \.self) { index in
                        let tag = tags[index]
                        
                        concaterator(index, in: tags.count)

                        Text(labelName(for: tag, at: index, of: tags.count))
                            .foregroundStyle(tag.color(for: colorScheme))
                            .symbolVariant(.fill)
                    }
                }
                .lineLimit(1)
                .multilineTextAlignment(.leading)
            } icon: {
                gradientBookmark
            }

            
        }
    }

    @ViewBuilder
    var longest: some View {
        switch tags.count {
        case 0, 1:
            short
        default:
  
            Label {
                HStack {
                    ForEach(0 ..< tags.count, id: \.self) { index in
                        let tag = tags[index]
                        
                        concaterator(index, in: tags.count)

                        Text(labelName(for: tag, at: index, of: tags.count))
                            .foregroundStyle(tag.color(for: colorScheme))
                            .symbolVariant(.fill)
                    }
                }
                .lineLimit(1)
                .multilineTextAlignment(.leading)
            } icon: {
                stackedBookmarks
            }
        }
    }
    
    @ViewBuilder
    private func concaterator(_ index: Int, in count: Int) -> some View {
        if index == count - 1 {
            Text(predicate.concatenator)
                .foregroundStyle(.secondary)
        }
    }

    private func labelName(for tag: TagInfo, at index: Int, of count: Int) -> String {
        tag.name + (index < count - 2 ? ", " : "")
    }
    
    var body: some View {
        // TODO: I could probably refaactor this
        // so that it's just a Label containing 2 ViewThatFits
        // one for image and one for title
        // TODO: different font weights for tag name vs concatenator string
        HStack {
            ViewThatFits {
                longest
                longer
                long
                short
                shorter
                shortest
            }
            Spacer()
        }
    }
}

#if DEBUG

#Preview {
    
    @Previewable @State var width: CGFloat = 200
    @Previewable @State var predicate = TagsPredicateType.allTags

    VStack(alignment: .leading) {
        ForEach(0 ..< ExampleTagsSource.examples.count, id: \.self) { index in
            let tags = ExampleTagsSource.examples[index]
            Text("\(tags.count) tags")
                .font(.headline)
            HStack {
                SelectedTagsSummary(tags: tags.tags, predicate: predicate)
                    .frame(width: width)
                    .padding(.bottom)
                    .debuggingBorder(.secondary.opacity(0.2))
                Spacer()
            }
        }
        
        Slider(value: $width, in: 30 ... 400)
        Picker("Predicate", selection: $predicate) {
            ForEach(TagsPredicateType.allCases) {
                Text($0.displayName)
            }
        }
        .pickerStyle(.segmented)
    }
    .padding()
    .frame(width: 400)
}
#endif
