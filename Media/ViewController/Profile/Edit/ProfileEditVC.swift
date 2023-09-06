//
//  ProfileEditVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit
import BaseFrameWork

protocol ProfileEditVCDelegate {
    func receiveProfileData(profileMenu: ProfileMenu)
}

class ProfileEditVC: BaseViewController {

    override var isShowDeinit: Bool { true }
    
    let mainView = ProfileEditView()
    var menu: ProfileMenu?
    
    var delegate: ProfileEditVCDelegate?
    var completionHandler: ((ProfileMenu) -> Void)?
    
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
            mainView.editTextField.text = menu.content.isEmpty ? nil : menu.content
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
            showAlert(title: "오류", msg: "입력해주세요", ok: "확인")
        } else {
            guard let menu else { return }
            switch menu.type {
            case .name:
                NotificationCenter.default.post(name: .name, object: nil, userInfo: ["name" : ProfileMenu(type: menu.type, content: input)])
            case .username:
                NotificationCenter.default.post(name: .username, object: nil, userInfo: ["username" : ProfileMenu(type: menu.type, content: input)])
            case .genderPronoun:
                delegate?.receiveProfileData(profileMenu: ProfileMenu(type: menu.type, content: input))
            case .introduce:
                delegate?.receiveProfileData(profileMenu: ProfileMenu(type: menu.type, content: input))
            case .link:
                completionHandler?(ProfileMenu(type: menu.type, content: input))
            case .gender:
                completionHandler?(ProfileMenu(type: menu.type, content: input))
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
}
