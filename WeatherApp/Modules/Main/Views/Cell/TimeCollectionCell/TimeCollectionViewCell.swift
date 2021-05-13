//
//  TimeCollectionViewCell.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol TimeCollectionViewCellProtocol: AnyObject {
    func configurateCell(weatherList: [ThreeHoursWeatherModelList], indexPath: IndexPath)
}

final class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var weatherImage: UIImageView!
    @IBOutlet private var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        containerView.backgroundColor = UIColor(hexString: StringValues.lightHexColor)
    }
    
    override func prepareForReuse() {
        timeLabel.text = nil
        tempLabel.text = nil
        weatherImage.image = nil
    }
    
    func configurateCell(weatherList: [ThreeHoursWeatherModelList], indexPath: IndexPath) {
        let time = weatherList[indexPath.row].dtTxt?.components(separatedBy: " ")
        DispatchQueue.main.async {
            self.display(time: time?.last)
            self.display(temp: "\(Int(weatherList[indexPath.item].main?.temp ?? 0) - 273) °C")
            self.display(image: weatherList[indexPath.item].weather?.first?.icon)
        }
    }
}

extension TimeCollectionViewCell: TimeCollectionViewCellProtocol {
    func display(time: String?) {
        timeLabel.text = time
    }
    
    func display(temp: String?) {
        tempLabel.text = temp
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
