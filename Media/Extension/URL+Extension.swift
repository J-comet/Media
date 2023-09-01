//
//  URL+Extension.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import Foundation

extension URL {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let imgURL = "https://image.tmdb.org/t/p/w400/"
    static let peopleImgURL = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/"
    static let youtubeURL = "https://www.youtube.com/watch?v="
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
    
    static func getImg(imgaePath: String) -> String {
        return imgURL + imgaePath
    }
    
    static func getYoutubeLink(key: String) -> String {
        return youtubeURL + key
    }
    
    static func getProfileImg(profilePath: String) -> String {
        return peopleImgURL + profilePath
    }
}
