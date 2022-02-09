//
//  DailyResponse.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation

// MARK: - Welcome
typealias DailyWeatherItems = [DailyWeather]

struct City: Codable {
    let id: Int
    let name: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
    }
}

struct DailyResponse: Codable {
    let city: City?
    let list: DailyWeatherItems?
    var time: Date?
    
    enum CodingKeys: String, CodingKey {
        case list
        case city
        case time
    }
}


struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
    
    enum CodingKeys: String, CodingKey {
        case day, min, max, night
        case eve, morn
    }
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case main, description, icon
    }
}


struct DailyWeather: Codable {
    let dt: Double
    let pressure: Int
    let humidity: Int
    let temp: Temp
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt
        case pressure
        case humidity
        case temp
        case weather
    }
}
