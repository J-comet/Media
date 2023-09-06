//
//  EndPoint.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

enum Endpoint {
    case movieGenre
    case tvGenre
    case trend(type: APIType, period: String)
    case cast(type: APIType, id: String)
    case tvOnTheAir
    case tvDetail(sereiesId: String)
    case tvSeasonDetail(sereiesId: String, seasonNumber: String)
    case similar(movieId: String)
    case movieVideos(movieId: String)
    
    
    var requestURL: String {
        switch self {
        case .movieGenre:
            return URL.makeEndPointString("genre/movie/list")
        case .tvGenre:
            return URL.makeEndPointString("genre/tv/list")
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
            
        case .similar(movieId: let id):
            return URL.makeEndPointString("movie/\(id)/similar")
            
        case .movieVideos(movieId: let id):
            return URL.makeEndPointString("movie/\(id)/videos")
        
        }
    }
}
