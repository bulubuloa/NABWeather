//
//  Double+Ex.swift
//  NABWeather
//
//  Created by Omnimobile on 2/7/22.
//

import Foundation

extension Double {
    func wrapInt() -> String {
        return String(format: "%.0f", self)
    }
}
