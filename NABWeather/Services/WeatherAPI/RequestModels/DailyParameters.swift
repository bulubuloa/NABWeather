//
//  DailyParameters.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation

enum WeatherUnits: String {
    case temp = "Temperature"
    case unitdefault = "Unit Default"
    case metric = "Metric"
    case celsius = "Celsius"
    case imperial = "Imperial"
    case fahrenheit = "Fahrenheit"
}

struct DailyParameters: WebAPIParameters{
    var q: String
    var cnt: Int?
    var appid: String
    var units: String?
}
