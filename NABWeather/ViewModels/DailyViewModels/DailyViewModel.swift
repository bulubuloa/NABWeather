//
//  DailyViewModel.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation
import RxSwift
import RxCocoa


class DailyViewModel: BaseViewModel {
    
    lazy var weatherAPI: IWeatherAPI = {
        var service = WeatherAPI()
        return service
    }()
    
    struct Input {
        let searchParameters: BehaviorRelay<String?>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let results: BehaviorRelay<[DailyWeather]>
        let errors: Driver<Error>
        let flagFromCache: Driver<Bool>
    }
    
    func makeBinding(input: Input) -> Output {
        let queryResult = BehaviorRelay<[DailyWeather]>(value: [])
        let loading = BehaviorRelay<Bool>(value: false)
        let fromCache = BehaviorRelay<Bool>(value: true)
        
        //Empty query -> just return empty array
        let observableEmptyQuery = input.searchParameters
            .filter { item in return item == nil || item!.count == 0 }
            .map { keyword -> [DailyWeather] in return [] }
            .catchAndReturn([])
        
        //Convert valid parameters to observable get data
        let observableQueryResponse = input.searchParameters
            .compactMap { $0 }
            .filter { keyword in keyword.count >= 3 }
            .map { [unowned self] keyword in self.keyword2Parameters(keyword: keyword) }
            .flatMapLatest { [unowned self]
                parameter -> Observable<Event<DailyResponse>> in
                
                let cacheItems = WeatherDataManager.share.weatherItems(keyword: parameter.q, limit: 1)
                if cacheItems.count > 0 {
                    let cache = cacheItems[0]
                    if let diff = Utils.diffMins(date1: cache.date!, date2: Date.now), diff <= 60, var cacheResponse = decodeCache(jsonString: cache.data) {
                        cacheResponse.time = cache.date!
                        return Observable.just(cacheResponse).materialize()
                    }
                }
                return self.weatherAPI.daily(parameters: parameter).retry(3).asObservable().materialize()
            }
            .share()
        
        //Filter valid data to share business
        let observableValidData = observableQueryResponse
            .compactMap { item in return item.element }
            .do(
                onNext: {
                    displayData in
                    if displayData.time == nil {
                        WeatherDataManager.share.weatherSave(keyword: input.searchParameters.value, displayData: displayData)
                    }
                }
            )
            .share()
        
        //Bind data and do some stuffs
        let observableQueryData = observableValidData
            .map { item in return item.list ?? [] }
            .share()
        
        //Bind flag get from cache to to some stuffs
        observableValidData
            .map { item in item.time != nil }
            .bind(to: fromCache)
            .disposed(by: disposeBag)
    
        //Filter error to handle
        let observableError = observableQueryResponse
            .compactMap { $0.error }
//            .subscribe(
//                onNext: {
//                    item in
//                    //handle error here
//                }
//            )
        
        // or handle error here
        //        observableQueryResponse.subscribe(
        //            onError: {
        //                error in
        //                print("observableQueryResponse => \(error)")
        //            }
        //        )
        
        
        let observableResult = Observable.merge(
            observableEmptyQuery,
            observableQueryData)
        
        observableResult
            .bind(to: queryResult)
            .disposed(by: disposeBag)
        
        //tracking loading state if it needed
        Observable.merge(
            input.searchParameters.map { _ in true },
            observableResult.map { _ in false })
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        return Output(
            loading: loading.asDriver(),
            results: queryResult,
            errors: observableError.asDriver(onErrorJustReturn: WebAPIError.unknow("Unknow")),
            flagFromCache: fromCache.asDriver(onErrorJustReturn: false))
    }
    
    func keyword2Parameters(keyword: String) -> DailyParameters {
        return DailyParameters(
            q: keyword,
            cnt: WeatherAPIConstants.WeatherDayOfQueries,
            appid: WeatherAPIConstants.WeatherAPIKey,
            units: WeatherUnits.metric.rawValue)
    }
    
    func decodeCache(jsonString: String?) -> DailyResponse? {
        guard let string = jsonString else {
            return nil
        }
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        let response = try? JSONDecoder().decode(DailyResponse.self, from: data)
        return response
    }
}
