//
//  MainWeatherView.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol MainWeatherViewProtocol: class {
    func display(day: String?)
    func display(temp: String?)
    func display(persent: String?)
    func display(speed: String?)
    func display(image: String?)
}

final class MainWeatherView: UIView {
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var weatherImage: UIImageView!
    @IBOutlet private var speedLabel: UILabel!
    @IBOutlet private var persentLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor(hexString: StringValues.blueHexColor)
    }
}

extension MainWeatherView: MainWeatherViewProtocol {
    func display(day: String?) {
        dayLabel.text = day
    }
    
    func display(temp: String?) {
        temperatureLabel.text = temp
    }
    
    func display(persent: String?) {
        persentLabel.text = persent
    }
    
    func display(speed: String?) {
        speedLabel.text = speed
    }
    
    func display(image: String?) {
        let imageString = ChooseImage(imageName: image)
        
        if let icon = UIImage(named: imageString.iconName) {
            self.weatherImage.image = icon
        } else {
            self.weatherImage.load(imageName: imageString.iconName)
        }
    }
}
