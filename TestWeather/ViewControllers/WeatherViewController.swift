//
//  WeatherViewController.swift
//  TestWeather
//
//  Created by admin on 10.08.2022.
//

import UIKit
import CoreLocation
import Kingfisher


struct DaysWeather {
    var day: String
    var hourlyWeather: [HourlyCityWeather]
}

class WeatherViewController: UIViewController, CLLocationManagerDelegate, WeatherCityPresenterDelegate, MapViewControllerDelegate {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    private var presenter = WeatherPresenter()
    
    var latitude: Double = 0
    var longitude: Double = 0
    var needSelfCoordinates: Bool = true
    private var hourlyCityWeather: [HourlyCityWeather] = []
    private var daysWeather: [DaysWeather] = []
    
    // MARK: - Constants
    struct Constants {
        static let collectionCellHeight: CGFloat = 140
        static let collectionCellWidth: CGFloat = 80
        static let tableCellHeight: CGFloat = 60
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionAndTableViews()
        presenter.setViewDelegate(delegate: self)
        setLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.tableView.isHidden = toInterfaceOrientation.isLandscape
        self.collectionView.isHidden = toInterfaceOrientation.isLandscape
    }
    
    
    func setCollectionAndTableViews() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "hourlyCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: Constants.collectionCellWidth, height: Constants.collectionCellHeight)
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "DayWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "dayCell")
    }
    
    func setLocationManager() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        if needSelfCoordinates {
            self.getCityWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            self.needSelfCoordinates = false
        }
    }
    
    func getCityWeather(lat: Double, lon: Double) {
        self.latitude = lat
        self.longitude = lon
        presenter.getCurrentCityWeather(lat: String(lat), lon: String(lon))
        presenter.getHourlyCityWeather(lat: String(lat), lon: String(lon))
    }
    
    
    // MARK: Presenter Delegate
    func presentCurrentCityWeather(cityWeatherData: CurrentWeatherModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let icon: String = cityWeatherData.weather.first?.icon ?? ""
            let iconUrl = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            self.iconImageView.kf.setImage(with: iconUrl)
            self.tempLabel.text = "\(ConvertTemperature.shared.convertTemp(temp: cityWeatherData.main.tempMax, from: .kelvin, to: .celsius)) / \(ConvertTemperature.shared.convertTemp(temp: cityWeatherData.main.tempMin, from: .kelvin, to: .celsius))"
            self.humidityLabel.text = "\(cityWeatherData.main.humidity) %"
            self.windSpeedLabel.text = "\(cityWeatherData.wind.speed) m/s"
        }
    }
    
    func presentHourlyCityWeather(cityWeatherData: HourlyWeatherModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.cityNameLabel.text = cityWeatherData.city.name
            self.currentDateLabel.text = Date().getCurrentDate()
            self.hourlyCityWeather = cityWeatherData.list
            self.collectionView.reloadData()
            
            self.daysWeather.removeAll()
            let days: [String] = Array(Set(self.hourlyCityWeather.map({Date().getDay(time: $0.dt)})))
            for i in days {
                let hourlyWeatherArray: [HourlyCityWeather] = cityWeatherData.list.filter({Date().getDay(time: $0.dt) == i})
                self.daysWeather.append(DaysWeather(day: i, hourlyWeather: hourlyWeatherArray))
                self.daysWeather.sort(by: {$0.hourlyWeather.first?.dt ?? 0 < $1.hourlyWeather.first?.dt ?? 0})
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: MapViewControllerDelegate
    func getNewCoordinates(lat: Double, lon: Double) {
        self.needSelfCoordinates = false
        self.getCityWeather(lat: lat, lon: lon)
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
    
    
    // MARK: IBAction
    @IBAction func openMapAction(_ sender: UIButton) {
        let mapVC = MapViewController.instantiateFromAppStoryboard(appStoryboard: .MapStoryboard)
        mapVC.latitude = self.latitude
        mapVC.longitude = self.longitude
        mapVC.cityName = self.cityNameLabel.text ?? ""
        mapVC.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyCityWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(data: hourlyCityWeather[indexPath.item])
        return cell
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.daysWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayWeatherTableViewCell else { return UITableViewCell() }
        cell.setDayWeather(data: daysWeather[indexPath.row])
        cell.scrollAction = { [weak self] day in
            guard let self = self else { return }
            let index = self.hourlyCityWeather.firstIndex(where: {Date().getDay(time: $0.dt) == day})
            self.collectionView.scrollToItem(at: IndexPath(item: index ?? 0, section: 0), at: .left, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableCellHeight
    }
}
