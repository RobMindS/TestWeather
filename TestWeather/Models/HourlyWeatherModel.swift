//
//  WeatherData.swift
//  TestWeather
//
//  Created by admin on 10.08.2022.
//

import Foundation

struct WeatherData: Decodable {
    var list: [HourlyCityWeather]
    var city: City
}

struct HourlyCityWeather: Decodable {
    
    var dt: Int = 0
    var main: Main
    var weather: [Weather]
    var wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case wind = "wind"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt = try container.decode(Int.self, forKey: .dt)
        main = try container.decode(Main.self, forKey: .main)
        weather = try container.decode([Weather].self, forKey: .weather)
        wind = try container.decode(Wind.self, forKey: .wind)
    }
}

struct Main: Decodable {
    var temp: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var humidity: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity = "humidity"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        tempMin = try container.decode(Double.self, forKey: .tempMin)
        tempMax = try container.decode(Double.self, forKey: .tempMax)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }
}

struct Weather: Decodable {
    var id: Int = 0
    var main: String = ""
    var description: String = ""
    var icon: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        icon = try container.decode(String.self, forKey: .icon)
    }
}

struct Wind: Decodable {
    var speed: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Double.self, forKey: .speed)
    }
}

struct City: Decodable {
    var name: String = ""
    var country: String = ""
    var timezone: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case country = "country"
        case timezone = "timezone"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        timezone = try container.decode(Int.self, forKey: .timezone)
    }
}
