//
//  GradientColoredImage.swift
//  BookmarkTags
//
//  Created by Joseph Wardell on 2/1/25.
//

import SwiftUI

struct GradientColoredImage: View {
    
    let systemImageName: String
    let colors: [Color]

    var body: some View {
        Image(systemName: systemImageName)
            .foregroundStyle(AngularGradient(colors: colors, center: .center))
     }
}
