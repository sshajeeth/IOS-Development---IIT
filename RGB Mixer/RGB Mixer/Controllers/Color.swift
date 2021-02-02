//
//  Color.swift
//  RGB Mixer
//
//  Created by Shajeeth Suwarnarajah on 2021-02-03.
//

import Foundation
import UIKit

class Color{
    
//    Initializing Variables
    var red_value:Float = 0.0
    var green_value:Float = 0.0
    var blue_value:Float = 0.0
    
//    initiliazing constant - RGB Maximum Range
    let rgb_range:Float = 255.0
    
    
    init(red: Float, green: Float, blue:Float) {
        red_value = red
        green_value = green
        blue_value = blue
    }
    
    
//    getting color method
    func getColor() -> UIColor {
       let generated_color = UIColor(red:CGFloat (red_value/rgb_range), green: CGFloat(green_value/rgb_range), blue: CGFloat(blue_value/rgb_range), alpha: 1)
        
        return generated_color
    }
}
