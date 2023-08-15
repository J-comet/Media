//
//  APIManager.swift
//  Media
//
//  Created by 장혜성 on 2023/08/11.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    let header: HTTPHeaders = ["Authorization":"Bearer \(APIKey.tmdbToken)"]
    
    func callRequest22(
        endPoint: Endpoint,
        completion: @escaping (JSON) -> (),
        failure: @escaping (String) -> Void,
        end: @escaping () -> Void
    ) {
//        print("url = ", url)
        let url = endPoint.requestURL
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                print(error)
                failure(error.errorDescription ?? "오류가 발생했습니다")
            }
            end()
        }
    }
    
    
    private func callRequest(
        url: String,
        completion: @escaping (JSON) -> (),
        failure: @escaping (String) -> Void,
        end: @escaping () -> Void
    ) {
        print("url = ", url)
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                print(error)
                failure(error.errorDescription ?? "오류가 발생했습니다")
            }
            end()
        }
    }
    
    func callTrendRequest(mediaType: String, period: String, page: Int,
                          completionHandler: @escaping (JSON) -> (),
                          failureHandler: @escaping (String) -> Void,
                          endHandler: @escaping () -> Void
    ) {
        let url = URL.requestTrendURL(type: mediaType, period: period, page: "\(page)")
        callRequest(url: url) { JSON in
            completionHandler(JSON)
        } failure: { error in
            failureHandler(error)
        } end: {
            endHandler()
        }
    }
    
    func callCreditRequest(mediaType: String, id: String,
                          completionHandler: @escaping (JSON) -> (),
                          failureHandler: @escaping (String) -> Void,
                          endHandler: @escaping () -> Void
    ) {
        let url = URL.requestCreditURL(type: mediaType, id: id)
        callRequest(url: url) { JSON in
            completionHandler(JSON)
        } failure: { error in
            failureHandler(error)
        } end: {
            endHandler()
        }
    }
}
