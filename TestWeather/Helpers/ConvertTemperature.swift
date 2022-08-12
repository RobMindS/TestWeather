//
//  ConvertTemp.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import Foundation

class ConvertTemp {
    
    let shared: ConvertTemp = ConvertTemp()
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
}
