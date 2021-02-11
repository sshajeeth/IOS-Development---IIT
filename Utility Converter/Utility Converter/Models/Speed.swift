//
//  Speed.swift
//  Utility Converter
//
//  Created by Shajeeth Suwarnarajah on 2021-02-10.
//

import Foundation

class Speed{
    var meter_per_seconds: Double;
    var kilometer_per_hour: Double;
    var miles_per_hour: Double;
    var noutical_miles_per_hour: Double;
    var speed_calculation_history : [String];
    
    init(meter_per_seconds:Double, kilometer_per_hour:Double, miles_per_hour:Double, noutical_miles_per_hour:Double) {
        self.meter_per_seconds = meter_per_seconds;
        self.kilometer_per_hour = kilometer_per_hour;
        self.miles_per_hour = miles_per_hour;
        self.noutical_miles_per_hour = noutical_miles_per_hour;
        self.speed_calculation_history = [String]();
    }
    
    
    
}
