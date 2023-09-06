//
//  VideoMovie.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import Foundation

// MARK: - VideoMovie
struct VideoMovie: Codable {
    let id: Int
    let results: [VideoMovieResult]
}

// MARK: - Result
struct VideoMovieResult: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
