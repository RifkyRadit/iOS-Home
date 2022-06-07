//
//  HomeViewModel.swift
//  iOS-Home-Exercise
//
//  Created by Administrator on 06/06/22.
//

import Foundation

enum StateView {
    case showIndicator
    case showContent
}

protocol HomeViewModelInput {
    func viewDidLoad(apiKey: String, city: String)
}

class HomeViewModel: HomeViewModelInput {
    
    let apiService: APIServiceProtocol
    
    var celciusValue: (String)->() = { _ in }
    var fahrenheitValue: (String)->() = { _ in }
    var errorMessage: (String)->() = { _ in }
    var stateView: (StateView) -> () = { _ in }
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func viewDidLoad(apiKey: String, city: String) {
        apiService.getWeatherData(apiKey: apiKey, city: city) { weatherData, error in
            DispatchQueue.main.async {
                guard let weatherData = weatherData, let currentWeather = weatherData.current else {
                    return
                }
                
                self.celciusValue(String(currentWeather.tempC))
                self.fahrenheitValue(String(currentWeather.tempF))
                self.stateView(.showContent)
            }
        }
    }
}
