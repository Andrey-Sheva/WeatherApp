//
//  DependencyContainer.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 09.05.2021.
//
import MapKit
import UIKit

final class DependencyContainer {
    private lazy var networkManager = NetworkManager<WeatherProvider>()
    private lazy var locationManager = CLLocationManager()
    private lazy var geocode = CLGeocoder()
}

extension DependencyContainer: ViewControllerFactory {
    func makeMainViewController() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiate(MainViewController.self)
        let presenter = MainPresenter(view: viewController, networkManager: networkManager)
        viewController.setupPresenter(presenter: presenter)
        return viewController
    }
    
    func makeMapViewController() -> MapViewController {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let viewController = storyboard.instantiate(MapViewController.self)
        let presenter = MapPresenter(view: viewController, locationManager: locationManager)
        viewController.setupGeocode(geocode: geocode)
        viewController.setupPresenter(presenter: presenter)
        
        return viewController
    }
}
