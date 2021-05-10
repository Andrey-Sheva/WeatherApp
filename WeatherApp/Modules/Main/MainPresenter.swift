//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import Foundation

protocol MainPresenterProtocol: class {
    init(view: MainViewControllerProtocol, networkManager: NetworkManager<WeatherProvider>)
    func configurateDayCell(cell: DayTableViewCellProtocol, indexPath: IndexPath)
    func configurateTimeCell(cell: TimeTableViewCellProtocol)
    func updateRequests(city: String)
    func didSelect(indexPath: IndexPath)
    func getDaysCount() -> Int
    func getHeightForCells() -> Int
}

final class MainPresenter: MainPresenterProtocol {
    private var view: MainViewControllerProtocol?
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
            let time = list[indexPath.row].dtTxt?.components(separatedBy: " ")
            cell.display(temp: "\(Int(list[indexPath.row].main?.temp ?? 0.0) - 273) °C")
            cell.display(day: time?.last)
            cell.display(image: list[indexPath.row].weather?.first?.icon)
        }
    }
    
    func didSelect(indexPath: IndexPath) {
        if let list = threeHoursWeather?.list {
            self.view?.configurateCurrentWeather(model: list[indexPath.row])
        }
    }
    
    func getDaysCount() -> Int {
        return 6
    }
    
    func getHeightForCells() -> Int {
        return 75
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
                self.view?.showErrorAlert(alertText: "Error", alertMessage: error.localizedDescription)
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
                self.view?.showErrorAlert(alertText: "Error", alertMessage: error.localizedDescription)
            }
        }
    }
}
