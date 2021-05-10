//
//  FiveDaysWeatherModel.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 04.05.2021.
//

import Foundation

// MARK: - Welcome
struct ThreeHoursWeatherModel: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [ThreeHoursWeatherModelList]?
    let city: ThreeHoursWeatherModelCity?
}

// MARK: - City
struct ThreeHoursWeatherModelCity: Codable {
    let id: Int?
    let name: String?
    let coord: ThreeHoursWeatherModelCoord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct ThreeHoursWeatherModelCoord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct ThreeHoursWeatherModelList: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [ThreeHoursWeatherModelWeather]?
    let clouds: ThreeHoursWeatherModelClouds?
    let wind: ThreeHoursWeatherModelWind?
    let visibility: Int?
    let pop: Double?
    let sys: ThreeHoursWeatherModelSys?
    let dtTxt: String?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct ThreeHoursWeatherModelClouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct ThreeHoursWeatherModelSys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct ThreeHoursWeatherModelWeather: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct ThreeHoursWeatherModelWind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
