//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 29.04.2021.
//

import Foundation
import Alamofire

protocol NetworkServiceBuilder: URLRequestConvertible {
    var baseURL: String {get}
    var method: HTTPMethod {get}
    var parameters: Parameters? {get}
    var headers: HTTPHeaders? {get }
    var path: String {get}
}

extension NetworkServiceBuilder {
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch method {
        case .get:
            request.allHTTPHeaderFields = headers?.dictionary
            request = try URLEncoding.default.encode(request, with: parameters)
        default:
            break
        }
        return request
    }
}


enum WeatherProvider: NetworkServiceBuilder {
    case currentWeather(city: String)
    case threeHours(city: String)
    
    var method: HTTPMethod {
        switch self {
        case .currentWeather:
            return .get
            
        case .threeHours:
            return .get
        }
    }
    var parameters: Parameters? {
        switch self {
        case .currentWeather(let city):
            return ["appid" : StringValues.apiKey,
                    "q" : String(describing: city),
                    "lang" : "ua"]
        case .threeHours(let city):
            return ["q" : String(describing: city),
                    "appid" : StringValues.apiKey,
                    "cnt" : "20",
                    "lang" : "ua"]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .threeHours:
            return "forecast"
        }
    }
}
