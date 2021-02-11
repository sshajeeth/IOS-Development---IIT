//
//  Temperature.swift
//  Utility Converter
//
//  Created by Shajeeth Suwarnarajah on 2021-02-10.
//

import Foundation

class Temperature{
    var celsius: Double;
    var farenheit: Double;
    var kelvin: Double;
    var temperature_calculation_history : [String];
    
    
    init(celsius:Double, farenheit:Double, kelvin:Double) {
        self.celsius = celsius;
        self.farenheit = farenheit;
        self.kelvin = kelvin;
        self.temperature_calculation_history = [String]()
    }
    
    
    
}
