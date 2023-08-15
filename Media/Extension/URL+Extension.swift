//
//  URL+Extension.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import Foundation

extension URL {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let imgURL = "https://image.tmdb.org/t/p/w400/"
    
    static func requestCreditURL(type: String, id: String) -> String {
        return URL.baseURL + "\(type)/\(id)/credits"
    }
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
