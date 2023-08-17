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
    
    func call<T: Codable>(
        endPoint: Endpoint,
        responseData: T.Type,
        parameterDic: [String:Any]? = nil,
        success: @escaping (_ response: T) -> (),
        failure: @escaping (_ error: String) -> Void,
        end: @escaping (_ endUrl: String) -> Void
    ){
        
        var parameters: Parameters = [:]
        if let parameterDic {
            parameterDic.forEach { (key: String, value: Any) in
                parameters.updateValue(value, forKey: key)
                
            }
            
//            for (key, value) in parameterDic {
//                parameters.updateValue(value, forKey: key)
//            }
        }
        
        let url = endPoint.requestURL
        AF.request(url, method: .get, parameters: parameters, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
                var requestStatus: String
                switch response.result {
                case .success(let data):
                    success(data)
                    requestStatus = "성공"
                case .failure(let error):
                    failure(error.errorDescription ?? "오류")
                    requestStatus = "실패"
                }
                end("======== \(url) ======== 호출 \(requestStatus)")
            }
    }
    
    func call(
        endPoint: Endpoint,
        completion: @escaping (JSON) -> (),
        failure: @escaping (_ error: String) -> Void,
        end: @escaping (_ endUrl: String) -> Void
    ) {
        let url = endPoint.requestURL
        print("url = ", url)
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
                var requestStatus: String
                switch response.result {
                case .success(let value):
                    requestStatus = "성공"
                    let json = JSON(value)
                    completion(json)
                case .failure(let error):
                    requestStatus = "성공"
                    print(error)
                    failure(error.errorDescription ?? "오류가 발생했습니다")
                }
                end("======== \(url) ======== 호출 \(requestStatus)")
            }
    }
}
