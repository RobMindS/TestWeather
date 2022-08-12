//
//  CitySearchPresenter.swift
//  TestWeather
//
//  Created by admin on 12.08.2022.
//

import Foundation
import UIKit

protocol CitySearchPresenterDelegate: AnyObject {
    func presentCities(cities: [CityModel])
}

typealias SearchPresenterDelegate = CitySearchPresenterDelegate & UIViewController

class CityPresenter {
    
    weak var delegate: SearchPresenterDelegate?
    
    public func getCities() {
        guard let path = Bundle.main.path(forResource: "city_list", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cityList = try decoder.decode([CityModel].self, from: data)
            self.delegate?.presentCities(cities: cityList)
        } catch {
            print("error: \(error)")
        }
    }
    
    public func setViewDelegate(delegate: SearchPresenterDelegate) {
        self.delegate = delegate
    }
}
