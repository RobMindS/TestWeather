//
//  CitySearchViewController.swift
//  TestWeather
//
//  Created by admin on 12.08.2022.
//

import UIKit

protocol CitySearchViewControllerDelegate {
    func showCityInMap(lat: Double, lon: Double, cityName: String)
}

class CitySearchViewController: UIViewController, UISearchBarDelegate, CitySearchPresenterDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    private var cities = [CityModel]()
    private var filterCities = [CityModel]()
    
    private let presenter = CityPresenter()
    
    var delegate: CitySearchViewControllerDelegate?
    
    // MARK: - Constants
    struct Constants {
        static let cellHeight: CGFloat = 50
        static let searchBarHeight: CGFloat = 40
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setSearchBar()
        presenter.setViewDelegate(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.getCities()
    }

    
    func setTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        self.activityIndicator.startAnimating()
    }

    func setSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: Constants.searchBarHeight))
        searchBar.placeholder = "Search city"
        searchBar.searchBarStyle = .default
        searchBar.showsCancelButton = true
        searchBar.keyboardType = .alphabet
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchTextField.textColor = .white
        self.navigationItem.titleView = self.searchBar
        self.navigationController?.navigationBar.topItem?.title = ""
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.cities = self.filterCities.filter{$0.name.lowercased().hasPrefix(searchText.lowercased()) }
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: Presenter Delegate
    func presentCities(cities: [CityModel]) {
        self.cities = cities
        self.filterCities = cities
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}


// MARK: - UITableViewDataSource, - UITableViewDelegate
extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        cell.cityNameLabel.text = cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.showCityInMap(lat: cities[indexPath.row].coord.lat, lon: cities[indexPath.row].coord.lon, cityName: cities[indexPath.row].name)
    }
    
}
