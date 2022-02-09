//
//  WeatherAPIConstants.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation

struct WeatherAPIConstants {
    static let WeatherAPI = "https://api.openweathermap.org/data/2.5/forecast"
    static let WeatherAPIIcon = "https://openweathermap.org/img/w/"
    static let WeatherCacheInMinutes = 60
    static let WeatherAPIKey = "60c6fbeb4b93ac653c492ba806fc346d"
    static let WeatherDayOfQueries = 7
}

enum WeatherEndpoint {
    case daily
}

extension WeatherEndpoint {
    var path: String {
        switch self {
        case .daily:
            return "/daily"
        }
    }
}
