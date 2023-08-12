//
//  MainVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class MainVC: BaseViewController {
   
    override func configNavVC() {
        // 네비게이션바 아래 라인 생기도록하기
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }

}
