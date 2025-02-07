//
//  TagToggle.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/23/25.
//

import SwiftUI

/// Shows a taq and gives the user the chance to toggle its selction on and off
/// This is used in the list of all tags to let the user choose tags
/// that they want to associate with a given bookmark
struct TagToggle: View {
    
    let viewModel: TagInfo
    let bookmarkEdge: BookmarkTagShaped.IndentedEdge

    let fullsize: Bool
    
    let buttonImageName: String?
    let buttonTitle: LocalizedStringKey
    let buttonAction: () -> Void
    let doubleTapAction: () -> Void
    
    @Binding private var isSelected: Bool
    
    @Environment(\.colorScheme) var colorScheme

    init(_ viewModel: TagInfo,
         _ bookmarkEdge: BookmarkTagShaped.IndentedEdge,
         isSelected: Binding<Bool>,
         fullsize: Bool = false,
         buttonImageName: String? = nil,
         buttonTitle: LocalizedStringKey = "",
         buttonAction: @escaping () -> Void = {},
         doubleTapAction: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.bookmarkEdge = bookmarkEdge
        self._isSelected = isSelected
        self.buttonImageName = buttonImageName
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.doubleTapAction = doubleTapAction
        self.fullsize = fullsize
    }
    
    @ViewBuilder
    private var accessoryButton: some View {
        if let buttonImageName {
            Button(buttonImageName, systemImage: buttonImageName, action: buttonAction)
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .opacity(13/34)
                .minimumTappableArea()
        }
    }
    
    var body: some View {
        HStack {
            
            if bookmarkEdge == .leading {
                accessoryButton
                    .foregroundStyle(viewModel.color(for: colorScheme))
                    .padding(.horizontal)
            }

            
            Toggle(isOn: $isSelected) {
                Text(viewModel.name)
            }
            .onLongPressGesture(perform: buttonAction)
            .toggleStyle(TagToggleStyle(bookmarkEdge: bookmarkEdge, color: viewModel.color(for: colorScheme), wide: fullsize))
            .onTapGesture(count: 2, perform: doubleTapAction)
            .animation(.easeInOut, value: isSelected)
            
            if bookmarkEdge == .trailing {
                
                accessoryButton
                    .foregroundStyle(viewModel.color(for: colorScheme))
                    .padding(.horizontal)
            }
        }
    }
    
    private struct TagToggleStyle: ToggleStyle {
        
        let bookmarkEdge: BookmarkTagShaped.IndentedEdge
        let color: Color
        let wide: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            Button {
                configuration.isOn.toggle()
            } label: {
                
                configuration.label
                    .modifier(
                        BookmarkTagShaped(
                            bookmarkedEdge: bookmarkEdge,
                            isExpanded: true,
                            isPressed: configuration.isOn,
                            minContentWidth: wide ? 144 : 89,
                            maxContentWidth: wide ? 233 : 144,
                            fullsize: wide,
                            color: color
                        )
                    )
            }
            .buttonStyle(.borderless)
        }
    }

}

fileprivate struct Example: View {
    
    @State private var var1 = false
    @State private var var2 = false
    @State private var var3 = false

    var body: some View {
        VStack {
            
            TagToggle(TagInfo(name: "something", colorHue: 45/360), .leading, isSelected: $var1)
                .frame(maxWidth: .infinity, alignment: .trailing)

            TagToggle(TagInfo(name: "something wide", colorHue: 45/360), .leading, isSelected: $var1, fullsize: true)
                .frame(maxWidth: .infinity, alignment: .trailing)

            TagToggle(TagInfo(name: "something else", colorHue: 90/360), .leading, isSelected: $var2)
                .frame(maxWidth: .infinity, alignment: .trailing)

            TagToggle(TagInfo(name: "and another thing", colorHue: 135/360), .leading, isSelected: $var3)
                .frame(maxWidth: .infinity, alignment: .trailing)

            TagToggle(TagInfo(name: "something", colorHue: 45/360), .trailing, isSelected: $var1)
                .frame(maxWidth: .infinity, alignment: .leading)

            TagToggle(TagInfo(name: "something else", colorHue: 90/360), .trailing, isSelected: $var2)
                .frame(maxWidth: .infinity, alignment: .leading)

            TagToggle(TagInfo(name: "and another thing", colorHue: 135/360), .trailing, isSelected: $var3)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            
            TagToggle(
                TagInfo(
                    name: "with info button",
                    colorHue: 180/360
                ),
                .trailing,
                isSelected: $var3,
                buttonImageName: "info.circle",
                buttonTitle: "show info for tag",
                buttonAction:
                    {
                        print("info button was tapped")
                    })
                .frame(maxWidth: .infinity, alignment: .leading)

            TagToggle(
                TagInfo(
                    name: "with info button",
                    colorHue: 180/360
                ),
                .leading,
                isSelected: $var3,
                buttonImageName: "info.circle",
                buttonTitle: "show info for tag",
                buttonAction:  {
                    print("info button was tapped")
                })
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
    }
}

#if DEBUG
#Preview {
    Example()
        .widerPreview()
}
#endif
