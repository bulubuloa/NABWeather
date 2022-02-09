//
//  BaseService.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation

protocol IBaseService {
    
}

class BaseService: IBaseService {
    lazy var webAPI: IWebAPI = {
        return WebAPI()
    }()
}
