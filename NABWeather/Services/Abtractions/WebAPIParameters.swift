//
//  WebAPIParameters.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation

protocol WebAPIParameters: Encodable {
    func dicts() -> [String: Any]
}

extension WebAPIParameters {
    func dicts() -> [String: Any] {
        let data = try! JSONEncoder.init().encode(self)
        let dictionary = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        return dictionary
    }
}
