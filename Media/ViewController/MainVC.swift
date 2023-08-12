//
//  MainVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class MainVC: BaseViewController {
   
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    var mediaList: [Media] = []
    
    var page = 1
    var totalPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.shared.callTrendRequest(mediaType: "movie", period: "week", page: page) { JSON in
            print(JSON)
            
            self.totalPage = JSON["total_pages"].intValue
            
            for item in JSON["results"].arrayValue {
                let media = Media(
                    id: item["id"].intValue,
                    mediaType: item["media_type"].stringValue,
                    title: item["title"].stringValue,
                    content: item["overview"].stringValue,
                    posterPath: item["poster_path"].stringValue,
                    backdropPath: item["backdrop_path"].stringValue,
                    date: item["release_date"].stringValue,
                    vote: item["vote_average"].doubleValue
                )
                self.mediaList.append(media)
            }
            self.mediaCollectionView.reloadData()
            
        } failureHandler: { error in
            print(error)
        }

    }
    
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
