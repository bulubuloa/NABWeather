//
//  WeatherDataManage.swift
//  NABWeather
//
//  Created by Omnimobile on 1/28/22.
//

import Foundation
import CoreData

typealias DailyWeatherModelItems = [DailyWeatherModel]

class WeatherDataManager {
    static let share = WeatherDataManager()
    
    let container = NSPersistentContainer(name: "NABWeather")
    //let cacheTimeInterval = TimeInterval.seconds(60*60)

    private init() {
        self.container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func weatherItems() -> [DailyWeatherModel] {
        let cacheItems = try? container.viewContext.fetch(DailyWeatherModel.fetchRequest())
        if let results = cacheItems {
            return results
        } else {
            return []
        }
    }
    
    func weatherItems(keyword: String, limit: Int? = nil) -> [DailyWeatherModel] {
        let fetchRequest = DailyWeatherModel.fetchRequest()
       
        let namePredicate = NSPredicate(
            format: "name LIKE[cd] %@", keyword
        )
        let keywordPredicate = NSPredicate(
            format: "keyword LIKE[cd] %@", keyword
        )
        fetchRequest.predicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: [namePredicate, keywordPredicate]
        )
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        if let numberOfRows = limit {
            fetchRequest.fetchLimit = numberOfRows
        }
        
        let cacheItems = try? container.viewContext.fetch(fetchRequest)
        if let results = cacheItems {
            return results
        } else {
            return []
        }
    }
    
    func weatherSave(keyword: String?, displayData: DailyResponse){
        if let keyword = keyword {
            if let city = displayData.city {
                let model = DailyWeatherModel(context: self.container.viewContext)
                model.id = Int32(city.id)
                model.keyword = keyword
                model.name = city.name
                model.date = Date.now
                model.data = String(data: try! JSONEncoder().encode(displayData), encoding: .utf8)
            }
            try? self.container.viewContext.save()
        }
    }
}
