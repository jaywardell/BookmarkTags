//
//  View+Accessibility.swift
//  Chatham
//
//  Created by Joseph Wardell on 3/31/23.
//

import SwiftUI

enum MultiplatformViewConstants {
    static var minimumTappableSize: CGFloat { 44 }
}

// MARK: -

extension Button {

    func minimumTappableArea() -> some View {
        #if os(iOS)
        self
            .containerShape(Rectangle())
            .frame(minWidth: MultiplatformViewConstants.minimumTappableSize,
                   minHeight: MultiplatformViewConstants.minimumTappableSize)
        #else
        self
        #endif
    }
}

// MARK: -

extension View {

    func minimumTappableArea() -> some View {
        #if os(iOS)
        self
            .frame(minWidth: MultiplatformViewConstants.minimumTappableSize,
                   minHeight: MultiplatformViewConstants.minimumTappableSize)

            // a tap will still not be accepted in areas where the view doesn't draw
            // make sure that a tap anywhere in the view will be registered
            .contentShape(Rectangle())
        #else
        self
        #endif
    }
}
