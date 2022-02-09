//
//  WebAPIError.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation

enum WebAPIError: Error {
    case inValidParameters(String)
    case inValidURL(String)
    case inValidJson(String)
    case expired(String)
    case unknow(String)
    case notfound(String)
}
