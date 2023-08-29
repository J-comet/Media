//
//  ProfileEditVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit

class ProfileEditVC: CodeBaseViewController {

    let mainView = ProfileEditView()
    var menu: ProfileMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configureView() {
        if let menu {
            title = "\(menu.type.title)"
            mainView.guideLabel.text = menu.type.title
            mainView.editTextField.placeholder = menu.type.placeHolder
        }
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(doneButtonClicked)
        )
        navigationItem.rightBarButtonItem?.tintColor = .link
    }

    @objc func doneButtonClicked() {
        guard let input = mainView.editTextField.text else {
            print("오류")
            return
        }
        
        if input.count < 1 {
            print("입력 값 없음")
        } else {
            print("굳")
        }
    }
}
