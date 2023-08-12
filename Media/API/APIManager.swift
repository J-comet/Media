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
    
    func requestTrendURL(type: String, period: String, page: String) -> String {
        return URL.baseURL + "trending/\(type)/\(period)?page=\(page)&language=ko"
    }
    
    func requestCreditURL(type: String, id: String) -> String {
        return URL.baseURL + "\(type)/\(id)/credits"
    }
    
    func callTrendRequest(mediaType: String, period: String, page: Int,
                          completionHandler: @escaping (JSON) -> (),
                          failureHandler: @escaping (String) -> Void,
                          endHandler: @escaping () -> Void
    ) {
//        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = requestTrendURL(type: mediaType, period: period, page: "\(page)")
        print("url = ", url)
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
            case .failure(let error):
                print(error)
                failureHandler(error.errorDescription ?? "오류가 발생했습니다")
            }
            endHandler()
        }
        
    }
}
