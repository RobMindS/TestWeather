//
//  Date+Helpers.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import Foundation

extension Date {
    
    func getHourAndMinutes(time: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
