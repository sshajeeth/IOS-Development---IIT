//
//  LiquidVolume.swift
//  Utility Converter
//
//  Created by Shajeeth Suwarnarajah on 2021-02-10.
//

import Foundation


class Liquid_Volume{
    var uk_gallon: Double;
    var litre: Double;
    var uk_pint: Double;
    var fluid_once: Double;
    var millilitre: Double;
    var liquid_volume_calculation_history : [String];
    
    init(uk_gallon:Double, litre:Double, uk_pint:Double, fluid_once:Double, millilitre:Double) {
        self.uk_gallon = uk_gallon;
        self.litre = litre;
        self.uk_pint = uk_pint;
        self.fluid_once = fluid_once;
        self.millilitre = millilitre;
        self.liquid_volume_calculation_history = [String]()
    }
    
    
    
}
