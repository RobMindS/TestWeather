//
//  WeatherPresenter.swift
//  TestWeather
//
//  Created by admin on 10.08.2022.
//

import Foundation
import UIKit

protocol WeatherCityPresenterDelegate: AnyObject {
    func presentCurrentCityWeather(cityWeatherData: CurrentWeatherModel)
    func presentHourlyCityWeather(cityWeatherData: HourlyWeatherModel)
}

typealias WeatherPresenterDelegate = WeatherCityPresenterDelegate & UIViewController

class WeatherPresenter {
    
    private let api = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = "c0ff0af889953630efae57dcaaa30aa1"
    
    weak var delegate: WeatherPresenterDelegate?
    
    
    public func getCurrentCityWeather(lat: String, lon: String) {
        guard let url = URL(string: api + "weather?lat=" + lat + "&lon=" + lon + "&appid=" + apiKey) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(CurrentWeatherModel.self, from: data)
                self.delegate?.presentCurrentCityWeather(cityWeatherData: weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    public func getHourlyCityWeather(lat: String, lon: String) {
        guard let url = URL(string: api + "forecast?lat=" + lat + "&lon=" + lon + "&appid=" + apiKey) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(HourlyWeatherModel.self, from: data)
                self.delegate?.presentHourlyCityWeather(cityWeatherData: weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    public func setViewDelegate(delegate: WeatherPresenterDelegate) {
        self.delegate = delegate
    }
}
