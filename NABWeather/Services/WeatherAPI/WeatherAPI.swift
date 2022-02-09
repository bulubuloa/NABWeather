//
//  WeatherAPI.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation
import RxSwift

protocol IWeatherAPI {
    func daily(parameters: DailyParameters) -> Single<DailyResponse>
}

class WeatherAPI: BaseService, IWeatherAPI {
    func daily(parameters: DailyParameters) -> Single<DailyResponse> {
        let endpoint = "\(WeatherAPIConstants.WeatherAPI)\(WeatherEndpoint.daily.path)"
        let ob: Single<DailyResponse> = webAPI.request(method: .get, enpoint: endpoint, requestModel: parameters)
        return ob
    }
}
