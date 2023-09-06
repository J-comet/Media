//
//  ProfileMenuList.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import Foundation

struct ProfileMenuInfo {
    static var list: [ProfileMenu] = [
        ProfileMenu(type: .name),
        ProfileMenu(type: .username),
        ProfileMenu(type: .genderPronoun),
        ProfileMenu(type: .introduce),
        ProfileMenu(type: .link),
        ProfileMenu(type: .gender)
    ]
}
