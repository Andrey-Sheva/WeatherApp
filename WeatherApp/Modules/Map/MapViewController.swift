//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 05.05.2021.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

protocol MapLoacationDelegate: AnyObject {
    func updateByMap(cityName: String)
}

protocol MapViewControllerProtocol: CLLocationManagerDelegate {
    func setupPresenter(presenter: MapPresenterProtocol)
    func setupDelegate(delegate: MapLoacationDelegate)
}

final class MapViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!
    private var selectedPin: MKPlacemark? = nil
    private var searchController: UISearchController?
    private let searchImage = UIImage(named: "ic_search")
    private let backImage = UIImage(named: "ic_back")
    private var presenter: MapPresenterProtocol?
    private var geocode: CLGeocoder?
    
    lazy var backButton: UIBarButtonItem = {
        let back = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backAction))
        return back
    }()
    
    weak var delegate: MapLoacationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupSearch()
    }
    
    // For fix navBar different heights
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    
    func setupSearch() {
        let storyboard = UIStoryboard(name: "Table", bundle: nil)
        let locationSearchTable = storyboard.instantiate(LocationTableView.self)
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController?.searchResultsUpdater = locationSearchTable
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Locations"
        locationSearchTable.handleMapSearchDelegate = self
        locationSearchTable.mapView = mapView
        
        if let search = searchController?.searchBar {
            search.setImage(UIImage(), for: .search, state: .normal)
            search.searchTextField.backgroundColor = .white
            search.searchTextField.textColor = .black
            search.delegate = self
            navigationItem.titleView = search
            navigationItem.leftBarButtonItems = [backButton]
        }
        definesPresentationContext = true
    }
    
    @objc func backAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Handle map touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var tempView = touch?.view
        while tempView != self.view {
            if tempView != mapView {
                tempView = tempView?.superview
            } else if tempView == mapView {
                break
            }
        }
        
        guard let location = touch?.location(in: mapView) else { return }
        let convertedCoordinate = mapView.convert((location), toCoordinateFrom: mapView)
        let annotation =  MKPointAnnotation()
        annotation.coordinate = convertedCoordinate
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MapViewControllerProtocol {
    func setupPresenter(presenter: MapPresenterProtocol) {
        self.presenter = presenter
    }
    
    func setupDelegate(delegate: MapLoacationDelegate) {
        self.delegate = delegate
    }
    
    func setupGeocode(geocode: CLGeocoder) {
        self.geocode = geocode
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController?.searchBar.setValue("", forKey: StringValues.cancelButton)
        searchController?.searchBar.setValue(searchImage, forKey: StringValues.cancelButton)
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        presenter?.requestLocation(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _ = locations.first {
            let region = MKCoordinateRegion(.world)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        presenter?.dropPinZoomIn(mapView: mapView, placemark: placemark, selectedPin: &selectedPin)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let location = view.annotation?.coordinate else { return }
        let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocode?.reverseGeocodeLocation(loc) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(alertText: StringValues.error, alertMessage: error.localizedDescription)
            }
            let placeMark = placemarks?.first
            if let city = placeMark?.locality {
                self.delegate?.updateByMap(cityName: city)
            }
        }
    }
}
