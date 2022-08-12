//
//  CurrentWeatherModel.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import Foundation

struct CurrentWeatherModel: Decodable {
    
    var weather: [Weather]
    var main: Main
    var wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
        case wind = "wind"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weather = try container.decode([Weather].self, forKey: .weather)
        main = try container.decode(Main.self, forKey: .main)
        wind = try container.decode(Wind.self, forKey: .wind)
    }
}
