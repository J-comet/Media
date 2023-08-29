//
//  ProfileVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit

class ProfileVC: CodeBaseViewController {
    
    private let mainView = ProfileView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavVC()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getEditDataNotificationObserver),
            name: .name,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getEditDataNotificationObserver),
            name: .username,
            object: nil
        )
    }
    
    @objc func getEditDataNotificationObserver(notification: NSNotification) {
        
        if let menu = notification.userInfo?["name"] as? ProfileMenu {
            ProfileMenuInfo.list.enumerated().forEach { idx, item in
                if item.type == menu.type {
                    ProfileMenuInfo.list[idx] = menu
                }
            }
            mainView.collectionView.reloadData()
        }
        
        if let menu = notification.userInfo?["username"] as? ProfileMenu {
            ProfileMenuInfo.list.enumerated().forEach { idx, item in
                if item.type == menu.type {
                    ProfileMenuInfo.list[idx] = menu
                }
            }
            mainView.collectionView.reloadData()
        }
    }

    private func configNavVC() {
        navigationItem.title = "프로필"
        navigationItem.rightBarButtonItem?.tintColor = .link
    }
    
    override func configureView() {
        navigationItem.backButtonDisplayMode = .minimal
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        
        mainView.thumbView.onClick = {
            print("click")
        }
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileMenuInfo.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileMenuCollectionViewCell.identifier, for: indexPath) as? ProfileMenuCollectionViewCell else { return UICollectionViewCell() }
        cell.configCell(row: ProfileMenuInfo.list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = ProfileMenuInfo.list[indexPath.row]
        let vc = ProfileEditVC()
        vc.menu = row
        
        // delegate
        if row.type == .genderPronoun || row.type == .introduce {
            vc.delegate = self
        }
        
        // closure
        if row.type == .link || row.type == .gender {
            vc.completionHandler = { menu in
                ProfileMenuInfo.list.enumerated().forEach { idx, item in
                    if item.type == menu.type {
                        ProfileMenuInfo.list[idx] = menu
                    }
                }
                self.mainView.collectionView.reloadData()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileVC: ProfileEditVCDelegate {
    
    func receiveProfileData(profileMenu: ProfileMenu) {
        print(profileMenu)
        ProfileMenuInfo.list.enumerated().forEach { idx, item in
            if item.type == profileMenu.type {
                ProfileMenuInfo.list[idx] = profileMenu
            }
        }
        mainView.collectionView.reloadData()
    }
}
