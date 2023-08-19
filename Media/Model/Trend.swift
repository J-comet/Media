//
//  Trend.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let trends = try? JSONDecoder().decode(Trends.self, from: jsonData)

import Foundation

// MARK: - Trends
struct Trends: Codable {
    let page: Int
    let results: [TrendsResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct TrendsResult: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle, overview, posterPath: String
    let mediaType: String
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func getGenre() -> String {
        var result = ""
        for genre in UserDefaults.genre {
            for id in genreIDS {
                if id == genre.id {
                    result.append("#\(genre.name) ")
                    break
                }
            }
        }
        return result
    }
    
    func getVoteAverage() -> String {
        return "\(round(voteAverage * pow(10, 2)) / pow(10, 2))"
    }
    
    func getReleaseDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: releaseDate)
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: date!)
    }
}

