//
//  MapPresenter.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 05.05.2021.
//

import Foundation
import MapKit

protocol MapPresenterProtocol: class {
    init(view: MapViewControllerProtocol, locationManager: CLLocationManager)
    func requestLocation(status: CLAuthorizationStatus)
    func dropPinZoomIn(mapView: MKMapView, placemark: MKPlacemark, selectedPin: inout MKPlacemark?)
}

final class MapPresenter: MapPresenterProtocol {
    
    weak var view: MapViewControllerProtocol?
    private let locationManager: CLLocationManager?
    
    required init(view: MapViewControllerProtocol, locationManager: CLLocationManager) {
        self.view = view
        self.locationManager = locationManager
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager?.delegate = self.view
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }
    
    func dropPinZoomIn(mapView: MKMapView, placemark: MKPlacemark, selectedPin: inout MKPlacemark?) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func requestLocation(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
    }
}
