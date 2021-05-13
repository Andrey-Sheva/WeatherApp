//
//  LocationTableView.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 05.05.2021.
//

import UIKit
import MapKit

final class LocationTableView: UITableViewController {
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(ResultsCell.self)
    }
}

extension LocationTableView {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: Search Results
extension LocationTableView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResultsForSearchController(searchController: searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = MKCoordinateRegion(.world)
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let self = self else { return }
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.reloadTableView()
        }
    }
}

// MARK: Delegates and DataSource
extension LocationTableView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(ResultsCell.self, indexPath)
        let text = "\(matchingItems[indexPath.row].placemark.country ?? ""), \(matchingItems[indexPath.row].placemark.description) "
        cell.display(city: text)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SizeStructure.locationHeight
    }
}
