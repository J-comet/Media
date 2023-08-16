//
//  EndPoint.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

enum Endpoint {
    case genre(language: String)
    case trend(language: String, type: String, period: String, page: String)
    case cast(type: String, id: String)
    case tvOnTheAir(language: String, page: String)
    case tvDetail(sereiesId: String)
    
    
    // TODO: 추후 쿼리들은 제거 후 paremeter 로 담아서 보내기
    var requestURL: String {
        switch self {
        case .genre(language: let language):
            return URL.makeEndPointString("genre/movie/list?language=\(language)")
        case .trend(language: let language, type: let type, period: let period, page: let page):
            return URL.makeEndPointString("trending/\(type)/\(period)?page=\(page)&language=\(language)")
        case .cast(type: let type, id: let id):
            return URL.makeEndPointString("\(type)/\(id)/credits")
        case .tvOnTheAir(language: let language, page: let page):
            return URL.makeEndPointString("tv/on_the_air?language=\(language)&page=\(page)")
        case .tvDetail(sereiesId: let sereiesId):
            return URL.makeEndPointString("tv/\(sereiesId)")
        }
    }
   
}
