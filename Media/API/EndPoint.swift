//
//  EndPoint.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

enum Endpoint {
    case genre
    case trend(type: APIType, period: String)
    case cast(type: APIType, id: String)
    case tvOnTheAir
    case tvDetail(sereiesId: String)
    case tvSeasonDetail(sereiesId: String, seasonNumber: String)
    
    
    var requestURL: String {
        switch self {
        case .genre:
            return URL.makeEndPointString("genre/movie/list")
            
        case .trend(type: let type, period: let period):
            return URL.makeEndPointString("trending/\(type.rawValue)/\(period)")
            
        case .cast(type: let type, id: let id):
            return URL.makeEndPointString("\(type.rawValue)/\(id)/credits")
            
        case .tvOnTheAir:
            return URL.makeEndPointString("tv/on_the_air")
            
        case .tvDetail(sereiesId: let sereiesId):
            return URL.makeEndPointString("tv/\(sereiesId)")
            
        case .tvSeasonDetail(sereiesId: let sereiesId, seasonNumber: let seasonNumber):
            return URL.makeEndPointString("tv/\(sereiesId)/season/\(seasonNumber)")
        }
    }
   
}
