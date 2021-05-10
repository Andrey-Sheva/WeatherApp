//
//  DayTableViewCell.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol DayTableViewCellProtocol: class {
    func display(day: String?)
    func display(temp: String?)
    func display(image: String?)
}

final class DayTableViewCell: UITableViewCell {
    
    @IBOutlet private var cloudImage: UIImageView!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var dayLabel: UILabel!
    
    private let blueColor: UIColor = UIColor(hexString: StringValues.blueHexColor)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.dropShadow(color: blueColor, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            setTextColor(color: blueColor)
        } else {
            contentView.dropShadow(color: .white, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 0, scale: true)
            setTextColor(color: .black)
            contentView.layer.borderWidth = 0
        }
    }
    
    override func prepareForReuse() {
        cloudImage.image = nil
        tempLabel.text = nil
        dayLabel.text = nil
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(hexString: StringValues.white)
    }
    
    private func setTextColor(color: UIColor) {
        dayLabel.textColor = color
        tempLabel.textColor = color
    }
    
}

extension DayTableViewCell: DayTableViewCellProtocol {
    func display(day: String?) {
        dayLabel.text = day
    }
    
    func display(temp: String?) {
        tempLabel.text = temp
    }
    
    func display(image: String?) {
        let imageString = ChooseImage(imageName: image)
        if let icon = UIImage(named: imageString.iconName) {
            self.cloudImage.image = icon
            self.cloudImage.setImageColor(color: .black)
        } else {
            self.cloudImage.load(imageName: imageString.iconName)
            self.cloudImage.setImageColor(color: .black)
        }
    }
}
