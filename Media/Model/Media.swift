//
//  Media.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import Foundation

struct Media {
    var id: Int
    var mediaType: String
    var title: String
    var content: String
    var posterPath: String
    var backdropPath: String
    var date: String
    var vote: Double
    
    func getCategory(type: String) -> String {
        return "#\(type.capitalized)"
    }
    
    func getVoteAverage(vote: Double) -> String {
        return "\(round(vote * pow(10, 2)) / pow(10, 2))"
    }
}
