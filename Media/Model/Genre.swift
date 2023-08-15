//
//  Genre.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
