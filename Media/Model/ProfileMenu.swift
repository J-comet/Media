//
//  ProfileMenu.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import Foundation

struct ProfileMenu {
    var type: ProfileMenuType
    var content: String = ""
}

enum ProfileMenuType: String, CaseIterable {
    case name
    case username
    case genderPronoun
    case introduce
    case link
    case gender
}

extension ProfileMenuType {
    var title: String {
        switch self {
        case .name:
            return "이름"
        case .username:
            return "사용자 이름"
        case .genderPronoun:
            return "성별 대명사"
        case .introduce:
            return "소개"
        case .link:
            return "링크"
        case .gender:
            return "성별"
        }
    }
    
    var placeHolder: String {
        switch self {
        case .name:
            return "이름을 입력해주세요"
        case .username:
            return "사용할 이름을 입력해주세요"
        case .genderPronoun:
            return "성별 대명사"
        case .introduce:
            return "소개를 작성해주세요"
        case .link:
            return "링크를 추가해주세요"
        case .gender:
            return "성별을 설정해주세요"
        }
    }
}
