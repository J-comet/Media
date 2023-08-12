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
    
    func getCategory() -> String {
        return "#\(mediaType.capitalized)"
    }
    
    func getVoteAverage() -> String {
        return "\(round(vote * pow(10, 2)) / pow(10, 2))"
    }
    
    func getReleaseDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: date!)
    }
}
