//
//  TimeCollectionViewCell.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol TimeCollectionViewCellProtocol: class {
    func display(time: String?)
    func display(temp: String?)
    func display(image: String?)
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
