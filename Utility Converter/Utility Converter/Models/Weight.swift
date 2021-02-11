//
//  Weight.swift
//  Utility Converter
//
//  Created by Shajeeth Suwarnarajah on 2021-02-10.
//

import Foundation


class Weight{
    var kilogram: Double;
    var grams: Double;
    var ounces: Double;
    var pounds: Double;
    var stone_pounds: Double;
    var weight_calculation_history : [String];
    
    
    init(kilogram:Double, grams:Double, ounces:Double, pounds:Double, stone_pounds:Double) {
        self.kilogram = kilogram;
        self.grams = grams;
        self.ounces = ounces;
        self.pounds = pounds;
        self.stone_pounds = stone_pounds;
        self.weight_calculation_history = [String]()
        
    }
}
