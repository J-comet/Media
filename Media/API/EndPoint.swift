//
//  EndPoint.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

enum Endpoint {
    case genre(language: String)

    var requestURL: String {
        switch self {
        case .genre(language: let language): return URL.makeEndPointString("genre/movie/list?language=\(language)")
        }
    }
   
}
