//
//  APIService.swift
//  iOS-Home-Exercise
//
//  Created by Administrator on 06/06/22.
//

import Alamofire

protocol APIServiceProtocol {
    func getWeatherData(apiKey: String, city: String, complete: @escaping (_ weatherData: Weather?, _ error: Error? )->() )
}

class UrlComponents {
    
    let apiKey: String
    let city: String
    let baseUrlString = "https://api.weatherapi.com/v1/current.json"
    var query = [String: String]()
    
    var url: String {
        query.updateValue(self.apiKey, forKey: "key")
        query.updateValue(self.city, forKey: "q")
        let queryString = query.convertQueryString.replacingOccurrences(of: " ", with: "%20")
        
        return [self.baseUrlString, queryString].joined()
    }
    
    init(apiKey: String, city: String) {
        self.apiKey = apiKey
        self.city = city
    }
}

class APIService: APIServiceProtocol {
    func getWeatherData(apiKey: String, city: String, complete: @escaping (Weather?, Error?) -> ()) {
        
        let urlComponents = UrlComponents(apiKey: apiKey, city: city)
        let urlString = urlComponents.url
        
        AF.request(urlString).response { response in
            guard let data = response.data else {
                return
            }

            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(Weather.self, from: data)
                complete(response, nil)

            } catch {
                complete(nil, error)
            }
        }
    }
    
    
    
}
