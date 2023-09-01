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
    let backdropPath: String?
    let id: Int
    let title: String?
    let name: String?
    let originalName: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let mediaType: String
    let genreIDS: [Int]?
    let popularity: Double
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    let profilePath: String?
    let knownFor: [PeopleKnownFor]?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title, name
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
    
    var genresInfo: [Genre] {
        if self.mediaType == APIType.movie.rawValue {
            return UserDefaults.movieGenre
        } else {
            return UserDefaults.tvGenre
        }
    }
    
    func getGenre() -> String {
        var result = ""
        if let genreIDS {
            for genre in genresInfo {
                for id in genreIDS {
                    if id == genre.id {
                        result.append("#\(genre.name) ")
                        break
                    }
                }
            }
        }
        return result
    }
    
    func getTitle() -> String {
        if let title {
            return title
        }
        if let name {
            return name
        }
        return "No Title"
    }
    
    func getOriginTitle() -> String {
        if let originalTitle {
            return originalTitle
        }
        if let originalName {
            return originalName
        }
        return "No Title"
    }
    
    func getVoteAverage() -> String {
        return "\(round((voteAverage ?? 0) * pow(10, 2)) / pow(10, 2))"
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if let releaseDate {
            let date = dateFormatter.date(from: releaseDate)
            dateFormatter.dateFormat = "MM/dd/YYYY"
            return dateFormatter.string(from: date!)
        }
        
        if let firstAirDate {
            let date = dateFormatter.date(from: firstAirDate)
            dateFormatter.dateFormat = "MM/dd/YYYY"
            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    func getKnownFor() -> String {
        var result = ""
        knownFor?.forEach({ item in
            result.append("\n#\(item.title)")
        })
        return "출연작품" + result
    }
}

struct PeopleKnownFor: Codable {
    let title: String
}

