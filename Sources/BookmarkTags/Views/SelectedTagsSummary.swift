//
//  SelectedTagsSummary.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/26/25.
//

import SwiftUI

struct SelectedTagsSummary: View {
    
    let tags: [TagInfo]

    private var bookmarkName: String { "bookmark" }

    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    var shortest: some View {
        switch tags.count {
        case 0:
            Image(systemName: bookmarkName)
                .foregroundStyle(.secondary)

        default:
            GradientColoredImage(systemImageName: bookmarkName, colors: tags.map { $0.color(for: colorScheme) })
                .symbolVariant(.fill)
        }
    }

    
    @ViewBuilder
    var shorter: some View {
        switch tags.count {
        case 0:
            Image(systemName: bookmarkName)
                .foregroundStyle(.secondary)

        default:
            HStack(spacing: 0) {
                ForEach(0 ..< tags.count, id: \.self) { index in
                    let tag = tags[index]
                    Image(systemName: bookmarkName)
                        .foregroundStyle(tag.color(for: colorScheme))
                        .symbolVariant(.fill)
                }
            }
        }
    }

    @ViewBuilder
    var short: some View {
        switch tags.count {
        case 0:
            Label(tags.keyedLabelTitle, systemImage: bookmarkName)
                .foregroundStyle(.secondary)
        case 1:
            Label(tags[0].name, systemImage: bookmarkName)
                .foregroundStyle(tags[0].color(for: colorScheme))
                .symbolVariant(.fill)
        default:
            
            Label {
                Text(tags.keyedLabelTitle)
                    .foregroundStyle(LinearGradient(colors: tags.map { $0.color(for: colorScheme) }, startPoint: .leading, endPoint: .trailing))
            } icon: {
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
                    Text(tag.name)
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
                        Text(tag.name)
                            .foregroundStyle(tag.color(for: colorScheme))
                            .symbolVariant(.fill)
                    }
                }
                .lineLimit(1)
                .multilineTextAlignment(.leading)
            } icon: {
                GradientColoredImage(systemImageName: bookmarkName, colors: tags.map { $0.color(for: colorScheme) })
                    .symbolVariant(.fill)
            }

            
        }
    }

    @ViewBuilder
    var longest: some View {
        switch tags.count {
        case 0, 1:
            short
        default:
            
            HStack {
                ForEach(0 ..< tags.count, id: \.self) { index in
                    let tag = tags[index]
                    Label(tag.name, systemImage: bookmarkName)
                        .foregroundStyle(tag.color(for: colorScheme))
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

#if DEBUG

#Preview {
    
    @Previewable @State var width: CGFloat = 200
    
    VStack(alignment: .leading) {
        ForEach(0 ..< ExampleTagsSource.examples.count, id: \.self) { index in
            let tags = ExampleTagsSource.examples[index]
            Text("\(tags.count) tags")
                .font(.headline)
            HStack {
                SelectedTagsSummary(tags: tags.tags)
                    .frame(width: width)
                    .padding(.bottom)
                    .debuggingBorder(.secondary.opacity(0.2))
                Spacer()
            }
        }
        
        Slider(value: $width, in: 30 ... 400)
    }
    .padding()
    .frame(width: 400)
}
#endif
