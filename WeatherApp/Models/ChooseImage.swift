//
//  ChooseImage.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 09.05.2021.
//

import Foundation

struct ChooseImage {
    var imageName: String?
    
    var iconName: String {
        switch imageName {
        case "01d":
            return "ic_white_day_bright"
        case "02d":
            return "ic_white_day_cloudy"
        case "03d":
            return "03d.png"
        case "04d":
            return "04d.png"
        case "09d":
            return "ic_white_day_rain"
        case "10d":
            return "ic_white_day_shower"
        case "11d":
            return "ic_white_day_thunder"
        case "13d":
            return "13d.png"
        case "50d":
            return "50d.png"
        case "01n":
            return "ic_white_night_bright"
        case "02n":
            return "ic_white_night_cloudy"
        case "03n":
            return "03n.png"
        case "04n":
            return "04n.png"
        case "09n":
            return "ic_white_night_shower"
        case "10n":
            return "10n.png"
        case "11n":
            return "ic_white_night_thunder"
        case "13n":
            return "13n.png"
        case "50n":
            return "50n.png"
        default:
            return "fail"
        }
    }
}
