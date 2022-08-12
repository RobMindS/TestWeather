//
//  MapViewController.swift
//  TestWeather
//
//  Created by admin on 11.08.2022.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func getNewCoordinates(lat: Double, lon: Double)
}

class MapViewController: UIViewController, UIGestureRecognizerDelegate, CitySearchViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: MapViewControllerDelegate?
    
    var latitude: Double = 0
    var longitude: Double = 0
    var cityName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBarButtonItem()
        setMapView(lat: latitude, lon: longitude, title: cityName)
        setLongPressGesture()
    }
    
    
    func setSearchBarButtonItem() {
        let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearchVC))
        self.navigationItem.rightBarButtonItem = searchBarButtonItem
    }
    
    func setMapView(lat: Double, lon: Double, title: String?) {
        let location = CLLocationCoordinate2D(latitude: lat,
                                              longitude: lon)
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title ?? ""
        mapView.addAnnotation(annotation)
    }
    
    func setLongPressGesture() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            setNewCoordinate(lat: locationCoordinate.latitude, lon: locationCoordinate.longitude, title: nil)
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    func setNewCoordinate(lat: Double, lon: Double, title: String?) {
        self.mapView.removeAnnotation(self.mapView.annotations.last!)
        setMapView(lat: lat, lon: lon, title: title)
        showAlert(lat: lat, lon: lon, title: title)
    }
    
    func showAlert(lat: Double, lon: Double, title: String?) {
        let actionSheetController: UIAlertController = UIAlertController(title: title ?? "Selected coordinates", message: "Would you like to see the weather in this place?", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)

        let yesActionButton = UIAlertAction(title: "Yes", style: .default) { _ in
            self.delegate?.getNewCoordinates(lat: lat, lon: lon)
            self.navigationController?.popViewController(animated: true)
        }
        actionSheetController.addAction(yesActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @objc func openSearchVC() {
        let searchVC = CitySearchViewController.instantiateFromAppStoryboard(appStoryboard: .CitySearchStoryboard)
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // MARK: CitySearchViewControllerDelegate
    func showCityInMap(lat: Double, lon: Double, cityName: String) {
        setNewCoordinate(lat: lat, lon: lon, title: cityName)
    }
}
