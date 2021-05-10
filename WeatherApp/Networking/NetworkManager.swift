//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 29.04.2021.
//

import Foundation
import Alamofire

final class NetworkManager<T: NetworkServiceBuilder> {
    func load<U: Codable>(service: T, decodeType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        guard let urlRequest = service.urlRequest else { return }
        AF.request(urlRequest).responseDecodable(of: U.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension UIImageView {
    func load(imageName: String) {
        let urlString = StringValues.imageUrl + imageName
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
