//
//  WebAPI.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation
import RxSwift
import Alamofire

protocol IWebAPI {
    func request<T: Codable>(method: WebAPIMethod, enpoint: String, requestModel: WebAPIParameters?) -> Single<T>
}

class WebAPI: IWebAPI {
    func request<T: Codable>(method: WebAPIMethod, enpoint: String, requestModel: WebAPIParameters?) -> Single<T> {
        var parameters: [String: Any] = [:]
        if let query = requestModel {
            parameters = query.dicts()
        }

        switch method {
            case .get:
                return requestGet(endpoint: enpoint, query: parameters)
            case .post:
                return requestPost(endpoint: enpoint, query: parameters)
        }
    }
    
    func requestGet<T: Codable>(endpoint: String, query: [String: Any] = [:]) -> Single<T> {
        let singleReturn = Single<T>.create {
            single in
            
//            print(endpoint)
//            print(query)
//
//            AF.request(endpoint, parameters: query)
//                .responseString {
//                    response in
//                    print(response)
//                }
            let request = AF.request(endpoint, parameters: query)
                .responseDecodable(of: T.self) {
                    response in
                    
                    guard let requestRespose = response.response else {
                        single(.failure(WebAPIError.unknow("Unknow error")))
                        return
                    }
                    print(requestRespose.statusCode)
                    switch requestRespose.statusCode {
                        case 200...201:
                            if let responseFinal = response.value {
                                single(.success(responseFinal))
                            } else {
                                single(.failure(WebAPIError.inValidJson("Json from response does not correct")))
                            }
                        case 404:
                            single(.failure(WebAPIError.expired("City not found")))
                        case 401:
                            single(.failure(WebAPIError.expired("Wrong API key")))
                        default:
                            single(.failure(WebAPIError.unknow("Unknow error")))
                    }
                }
                
            return Disposables.create() {
                request.cancel()
            }
        }
        return singleReturn
    }
    
    func requestPost<T: Codable>(endpoint: String, query: [String: Any] = [:]) -> Single<T> {
        return Single<T>.create {
            single in
            
            let request = AF.request(endpoint, method: .post, parameters: query, encoding: JSONEncoding.default)
                .responseDecodable(of: T.self) {
                    response in
                    guard let requestRespose = response.response else {
                        single(.failure(WebAPIError.unknow("Unknow error")))
                        return
                    }
                    
                    switch requestRespose.statusCode {
                        case 200...201:
                            if let responseFinal = response.value {
                                single(.success(responseFinal))
                            } else {
                                single(.failure(WebAPIError.inValidJson("Json from response does not correct")))
                            }
                        case 404:
                            single(.failure(WebAPIError.expired("City not found")))
                        case 401:
                            single(.failure(WebAPIError.expired("Wrong API key")))
                        default:
                            single(.failure(WebAPIError.unknow("Unknow error")))
                    }
                }
            
            return Disposables.create() {
                request.cancel()
            }
        }
    }
}
