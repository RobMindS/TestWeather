//
//  HourlyWeatherCollectionViewCell.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import UIKit
import Kingfisher

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var oclockLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(data: HourlyCityWeather) {
        self.oclockLabel.text = Date().getHourAndMinutes(time: data.dt)
        let icon: String = data.weather.first?.icon ?? ""
        let iconUrl = URL(string: "https://openweathermap.org/img/w/\(icon).png")
        self.iconImageView.kf.setImage(with: iconUrl)
        self.tempLabel.text = "\(ConvertTemperature.shared.convertTemp(temp: data.main.temp, from: .kelvin, to: .celsius))"
    }

}
