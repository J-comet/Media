//
//  EndPoint.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

enum Endpoint {
    case genre
    case trend(language: APILanguage, type: APIType, period: String, page: String)
    case cast(type: APIType, id: String)
    case tvOnTheAir(language: APILanguage, page: String)
    case tvDetail(sereiesId: String)
    case tvSeasonDetail(sereiesId: String, seasonNumber: String)
    
    
    // TODO: 추후 쿼리들은 제거 후 paremeter 로 담아서 보내기
    var requestURL: String {
        switch self {
        case .genre:
            return URL.makeEndPointString("genre/movie/list")
            
        case .trend(language: let language, type: let type, period: let period, page: let page):
            return URL.makeEndPointString("trending/\(type.rawValue)/\(period)?page=\(page)&language=\(language.rawValue)")
            
        case .cast(type: let type, id: let id):
            return URL.makeEndPointString("\(type.rawValue)/\(id)/credits")
            
        case .tvOnTheAir(language: let language, page: let page):
            return URL.makeEndPointString("tv/on_the_air?language=\(language.rawValue)&page=\(page)")
            
        case .tvDetail(sereiesId: let sereiesId):
            return URL.makeEndPointString("tv/\(sereiesId)")
            
        case .tvSeasonDetail(sereiesId: let sereiesId, seasonNumber: let seasonNumber):
            return URL.makeEndPointString("tv/\(sereiesId)/season/\(seasonNumber)")
        }
    }
   
}
