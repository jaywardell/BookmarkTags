//
//  Color+HSL.swift
//  TagViewsTests
//
//  Created by Joseph Wardell on 1/22/25.
//
// see https://stackoverflow.com/questions/62632213/swift-use-hsl-color-space-instead-of-standard-hsb-hsv answer by Kai Zheng
import SwiftUI

extension Color {
    init(hue: Double, saturation: Double, lightness: Double, opacity: Double = 1) {
        precondition(0...1 ~= hue &&
                     0...1 ~= saturation &&
                     0...1 ~= lightness &&
                     0...1 ~= opacity, "input range is out of range 0...1")
        
        //From HSL TO HSB ---------
        var newSaturation: Double = 0.0
        
        let brightness = lightness + saturation * min(lightness, 1-lightness)
        
        if brightness == 0 { newSaturation = 0.0 }
        else {
            newSaturation = 2 * (1 - lightness / brightness)
        }
        //---------
        
        self.init(hue: hue, saturation: newSaturation, brightness: brightness, opacity: opacity)
    }
}
