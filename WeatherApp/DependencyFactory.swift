//
//  DependencyFactory.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 09.05.2021.
//

import Foundation

protocol ViewControllerFactory: class {
    func makeMainViewController() -> MainViewController
    func makeMapViewController() -> MapViewController
}
