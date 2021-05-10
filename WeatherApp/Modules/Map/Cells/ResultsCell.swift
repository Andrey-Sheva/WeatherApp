//
//  ResultsCell.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 05.05.2021.
//

import UIKit

final class ResultsCell: UITableViewCell {

    @IBOutlet private var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func display(city: String) {
        self.cityLabel.text = city
    }
}
