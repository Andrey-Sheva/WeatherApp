//
//  ViewController.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol MainViewControllerProtocol: class {
    func setupPresenter(presenter: MainPresenterProtocol)
    func showErrorAlert(alertText: String, alertMessage: String)
    func configurateCurrentWeather(with model: CurrentWeatherModel)
    func configurateCurrentWeather(model: ThreeHoursWeatherModelList)
    func reloadTableView()
}

final class MainViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet private var mainWeatherView: UIView!
    @IBOutlet private var scrollView: UIScrollView!
    
    //MARK: Properties
    var container = DependencyContainer()
    
    var presenter: MainPresenterProtocol!
    private let mainWeather: MainWeatherView = .fromNib()
    private var date = Date().localizedDescription
    private let leftImage = UIImage(named: StringValues.barLabel)
    private let rightImage = UIImage(named: StringValues.rightBarButton)
    private let labelBarItem: UILabel = {
        var label = UILabel()
        label.text = "City"
        label.textColor = .white
        label.font = UIFont(name: "Thonburi-Bold", size: 23)
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupPresenter(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: Configurate Views
    private func setupViews() {
        setupMainWeatherView()
        setupNavBar()
        setupTableView()
        self.view.backgroundColor = UIColor(hexString: StringValues.blueHexColor)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(DayTableViewCell.self)
        tableView.registerCell(TimeTableViewCell.self)
        tableView.backgroundColor = UIColor(hexString: StringValues.blueHexColor)
    }
    
    private func setupMainWeatherView() {
        mainWeatherView.addSubview(mainWeather)
        mainWeather.frame = mainWeatherView.bounds
    }
    
    private func setupNavBar() {
        let leftBarIButton = UIBarButtonItem(image: leftImage, style: .done, target: nil, action: nil)
        let title = UIBarButtonItem(customView: labelBarItem)
        let rightBarIButton = UIBarButtonItem(image: rightImage, style: .done, target: self, action: #selector(pushToMap))
        navigationItem.leftBarButtonItems = [leftBarIButton, title]
        navigationItem.rightBarButtonItem = rightBarIButton
    }
    
    @objc func pushToMap() {
        navigateToMap()
    }
    
    func configurateCurrentWeather(with model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.mainWeather.display(day: "\(self.date)")
            self.mainWeather.display(persent: "\(model.main?.humidity ?? 0) %")
            self.mainWeather.display(speed: "\(model.wind?.speed ?? 0.0) м/сек")
            if let maxTemp = model.main?.tempMax, let minTemp =  model.main?.tempMin{
                self.mainWeather.display(temp: "\(Int(maxTemp - 273)) / \(Int(minTemp - 273)) °C") // -273 from kelvin to celsius
            }
            if let image = model.weather?.first?.icon {
                self.mainWeather.display(image: image)
            }
            self.labelBarItem.text = model.name
        }
    }
    
    func configurateCurrentWeather(model: ThreeHoursWeatherModelList) {
        DispatchQueue.main.async {
            self.mainWeather.display(day: model.dtTxt)
            self.mainWeather.display(temp: "\(Int(model.main?.temp ?? 0) - 273) °C")
            self.mainWeather.display(speed: "\(model.wind?.speed ?? 0.0) м/сек")
            self.mainWeather.display(persent: "\(model.main?.humidity ?? 0) %")
            
            if let image = model.weather?.first?.icon {
                self.mainWeather.display(image: image)
            }
        }
    }
}
