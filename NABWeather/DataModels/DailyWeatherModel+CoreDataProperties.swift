//
//  DailyWeatherModel+CoreDataProperties.swift
//  NABWeather
//
//  Created by Omnimobile on 2/1/22.
//
//

import Foundation
import CoreData


extension DailyWeatherModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherModel> {
        return NSFetchRequest<DailyWeatherModel>(entityName: "DailyWeatherModel")
    }

    @NSManaged public var data: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var keyword: String?
}

extension DailyWeatherModel : Identifiable {

}
