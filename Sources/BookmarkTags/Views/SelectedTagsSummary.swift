//
//  SelectedTagsSummary.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/26/25.
//

import SwiftUI

struct SelectedTagsSummary<T: TagsSource>: View {
    
    @ObservedObject var tags: T

    private var bookmarkName: String { "bookmark" }
        
    // TODO: this should be tags.selected
    // but right now I don't have a simple preview for that
    private var tagsToShow: [TagInfo] { tags.tags }

    private var gradientBookmarkImage: some View {
        Image(systemName: bookmarkName)
            .foregroundStyle(AngularGradient(colors: tagsToShow.map(\.color), center: .center))
            .symbolVariant(.fill)
    }
    
    @ViewBuilder
    var shortest: some View {
        switch tagsToShow.count {
        case 0:
            Image(systemName: bookmarkName)
                .foregroundStyle(.secondary)

        default:
            gradientBookmarkImage
        }
    }

    
    @ViewBuilder
    var shorter: some View {
        switch tagsToShow.count {
        case 0:
            Image(systemName: bookmarkName)
                .foregroundStyle(.secondary)

        default:
            HStack(spacing: 0) {
                ForEach(0 ..< tagsToShow.count, id: \.self) { index in
                    let tag = tagsToShow[index]
                    Image(systemName: bookmarkName)
                        .foregroundStyle(tag.color)
                        .symbolVariant(.fill)
                }
            }
        }
    }

    @ViewBuilder
    var short: some View {
        switch tagsToShow.count {
        case 0:
            Label(tagsToShow.keyedLabelTitle, systemImage: bookmarkName)
                .foregroundStyle(.secondary)
        case 1:
            Label(tagsToShow[0].name, systemImage: bookmarkName)
                .foregroundStyle(tagsToShow[0].color)
                .symbolVariant(.fill)
        default:
            
            Label {
                Text(tagsToShow.keyedLabelTitle)
                    .foregroundStyle(LinearGradient(colors: tagsToShow.map(\.color), startPoint: .leading, endPoint: .trailing))
            } icon: {
                HStack(spacing: -13) {
                    ForEach(0 ..< tagsToShow.count, id: \.self) { index in
                        let tag = tagsToShow[index]
                        Image(systemName: bookmarkName)
                            .foregroundStyle(tag.color)
                            .symbolVariant(.fill)
                            .zIndex(Double(-index))
                    }
                }
            }
        }
    }

    @ViewBuilder
    var long: some View {
        switch tagsToShow.count {
        case 0, 1:
            short
        default:
            
            HStack {
                ForEach(0 ..< tagsToShow.count, id: \.self) { index in
                    let tag = tagsToShow[index]
                    Text(tag.name)
                        .foregroundStyle(tag.color)
                        .symbolVariant(.fill)
                }
            }
            .lineLimit(1)
            .multilineTextAlignment(.leading)
        }
    }

    @ViewBuilder
    var longer: some View {
        switch tagsToShow.count {
        case 0, 1:
            short
        default:
            
            Label {
                HStack {
                    ForEach(0 ..< tagsToShow.count, id: \.self) { index in
                        let tag = tagsToShow[index]
                        Text(tag.name)
                            .foregroundStyle(tag.color)
                            .symbolVariant(.fill)
                    }
                }
                .lineLimit(1)
                .multilineTextAlignment(.leading)
            } icon: {
                gradientBookmarkImage
            }

            
        }
    }

    @ViewBuilder
    var longest: some View {
        switch tagsToShow.count {
        case 0, 1:
            short
        default:
            
            HStack {
                ForEach(0 ..< tagsToShow.count, id: \.self) { index in
                    let tag = tagsToShow[index]
                    Label(tag.name, systemImage: bookmarkName)
                        .foregroundStyle(tag.color)
                        .symbolVariant(.fill)
                }
            }
            .lineLimit(1)
            .multilineTextAlignment(.leading)
        }
    }

    var body: some View {
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

#Preview {
    
    @Previewable @State var width: CGFloat = 200
    
    VStack(alignment: .leading) {
        ForEach(0 ..< ExampleTagsSource.examples.count, id: \.self) { index in
            let tags = ExampleTagsSource.examples[index]
            Text("\(tags.count) tags")
                .font(.headline)
            HStack {
                SelectedTagsSummary(tags: tags)
                    .frame(width: width)
                    .padding(.bottom)
                    .debuggingBorder(.secondary.opacity(0.2))
                Spacer()
            }
        }
        
        Slider(value: $width, in: 30 ... 300)
    }
    .padding()
    .frame(width: 400)
}
