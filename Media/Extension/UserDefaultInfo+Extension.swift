//
//  UserDefaultInfo.swift
//  Media
//
//  Created by 장혜성 on 2023/08/15.
//

import Foundation

@propertyWrapper
struct UserDefaultStruct<T> where T: Codable {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.value(forKey: key) as? Data,
                  let decodedData = try? PropertyListDecoder().decode(T.self, from: data)
            else { return defaultValue }
            return decodedData
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefaultStruct(key: UserDefaultsKey.genre.rawValue, defaultValue: Array<Genre>())
    static var genre: [Genre]
}


enum UserDefaultsKey: String {
    case genre
}
