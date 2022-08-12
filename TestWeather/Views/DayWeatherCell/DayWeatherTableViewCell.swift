//
//  DayWeatherTableViewCell.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import UIKit
import Kingfisher

class DayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var scrollAction: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            self.dayNameLabel.textColor = UIColor(rgb: 0x5A9FF0)
            self.tempLabel.textColor = UIColor(rgb: 0x5A9FF0)
            scrollAction?(self.dayNameLabel.text ?? "")
        } else {
            self.dayNameLabel.textColor = .black
            self.tempLabel.textColor = .black
        }
    }
    
    
    func setDayWeather(data: DaysWeather) {
        self.dayNameLabel.text = data.day
        let temp = data.hourlyWeather.map({$0.main.tempMax})
        self.tempLabel.text = "\(ConvertTemperature.shared.convertTemp(temp: temp.max() ?? 0, from: .kelvin, to: .celsius)) / \(ConvertTemperature.shared.convertTemp(temp: temp.min() ?? 0, from: .kelvin, to: .celsius))"
        let icon: String = data.hourlyWeather.first?.weather.first?.icon ?? ""
        let iconUrl = URL(string: "https://openweathermap.org/img/w/\(icon).png")
        self.iconImageView.kf.setImage(with: iconUrl)
    }

}
