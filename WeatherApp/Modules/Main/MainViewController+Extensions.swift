//
//  MainViewController+Extensions.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

extension MainViewController: MainViewControllerProtocol {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showErrorAlert(alertText: String, alertMessage: String) {
        self.showAlert(alertText: alertText, alertMessage: alertMessage)
    }
    
    func navigateToMap() {
        let viewController = container?.makeMapViewController()
        viewController?.setupDelegate(delegate: self)
        if let controller = viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return SizeStructure.dayCell
        default:
            return SizeStructure.timeCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(by: indexPath.row)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getDaysCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.reusableCell(TimeTableViewCell.self, indexPath)
            presenter.configurateTimeCell(cell: cell)
            return cell
        default:
            let cell = tableView.reusableCell(DayTableViewCell.self, indexPath)
            presenter.configurateDayCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
}

extension MainViewController: MapLoacationDelegate {
    func updateByMap(cityName: String) {
        presenter.updateRequests(city: cityName)
    }
}
