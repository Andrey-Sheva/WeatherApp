//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func configurateDayCell(cell: DayTableViewCellProtocol, indexPath: IndexPath)
    func configurateTimeCell(cell: TimeTableViewCellProtocol)
    func updateRequests(city: String)
    func didSelect(by item: Int)
    func getDaysCount() -> Int
}

enum CellType {
    case day
    case time
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewControllerProtocol?
    private let networkManager: NetworkManager<WeatherProvider>?
    private var threeHoursWeather: ThreeHoursWeatherModel?
    
    private var city = "Vinnytsia" 
    
    typealias Completion = (() -> Void)
    
    required init(view: MainViewControllerProtocol, networkManager: NetworkManager<WeatherProvider>) {
        self.view = view
        self.networkManager = networkManager
        getCurrentWeather(city: city)
    }
    
    //MARK: Config cells
    func configurateTimeCell(cell: TimeTableViewCellProtocol) {
        cell.display(list: threeHoursWeather?.list ?? [])
        cell.reloadCollectionView()
    }
    
    func configurateDayCell(cell: DayTableViewCellProtocol, indexPath: IndexPath) {
        if let list = threeHoursWeather?.list {
            cell.configurateCell(weatherList: list, indexPath: indexPath)
        }
    }
    
    func didSelect(by item: Int) {
        if let list = threeHoursWeather?.list {
            self.view?.configurateCurrentWeather(model: list[item])
        }
    }
    
    func getDaysCount() -> Int {
        return 6
    }
    
    //MARK: Requests
    func updateRequests(city: String) {
        getCurrentWeather(city: city)
    }
    
    private func getCurrentWeather(city: String) {
        networkManager?.load(service: .currentWeather(city: city), decodeType: CurrentWeatherModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.view?.configurateCurrentWeather(with: data)
                    self.getThreeHoursDaysWeather(city: city)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(alertText: "Error", alertMessage: error.localizedDescription)
                }
            }
        }
    }
    
    private func getThreeHoursDaysWeather(city: String) {
        networkManager?.load(service: .threeHours(city: city), decodeType: ThreeHoursWeatherModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.threeHoursWeather = data
                    self.view?.reloadTableView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(alertText: "Error", alertMessage: error.localizedDescription)
                }
            }
        }
    }
}
