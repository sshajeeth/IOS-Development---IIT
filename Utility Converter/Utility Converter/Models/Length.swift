//
//  Length.swift
//  Utility Converter
//
//  Created by Shajeeth Suwarnarajah on 2021-02-10.
//

import Foundation


class Length{
    var meter: Double;
    var kilometer: Double;
    var mile: Double;
    var centimeter: Double;
    var millimeter: Double;
    var yard: Double;
    var inches: Double;
    var length_calculation_history : [String];
    
    init(meter:Double, kilometer:Double, mile:Double, centimeter:Double, millimeter:Double, yard:Double, inches:Double) {
        self.meter = meter;
        self.kilometer = kilometer;
        self.mile = mile;
        self.centimeter = centimeter;
        self.millimeter = millimeter;
        self.yard = yard;
        self.inches = inches;
        self.length_calculation_history = [String]();
        
    }
    
    
    
}
