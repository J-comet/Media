//
//  MainVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class MainVC: BaseViewController {
   
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    var mediaList: [Media] = [Media(id: 0, mediaType: "sd", title: "타이틀", content: "내용", posterPath: "이미지주소", date: "2022-10-10", vote: 3.3),
                              Media(id: 0, mediaType: "sd", title: "타이틀", content: "내용", posterPath: "이미지주소", date: "2022-10-10", vote: 3.3)]
    
    override func designVC() {
        setCollectionViewLayout()
    }
    
    override func configVC() {
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        
        let nib = UINib(nibName: MediaCollectionViewCell.identifier, bundle: nil)
        mediaCollectionView.register(nib, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
    }
    
    override func configNavVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(naviBarLeftButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .link
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(naviBarRightButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .link
    }

    @objc func naviBarLeftButtonClicked(_ sender: UIBarButtonItem) {
        print("왼쪽버튼 클릭")
    }
    
    @objc func naviBarRightButtonClicked(_ sender: UIBarButtonItem) {
        print("오른쪽버튼 클릭")
    }
    
    private func setCollectionViewLayout() {
        mediaCollectionView.showsVerticalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let count: CGFloat = 1
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        
        layout.itemSize = CGSize(width: width / count, height: width / count)
        layout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        mediaCollectionView.collectionViewLayout = layout
    }
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(row: mediaList[indexPath.row])
        return cell
    }
    
    
}
