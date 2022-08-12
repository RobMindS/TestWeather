//
//  AppStoryboard.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case WeatherStoryboard, MapStoryboard, CitySearchStoryboard
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}
