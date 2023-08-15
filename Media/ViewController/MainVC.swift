//
//  MainVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class MainVC: BaseViewController {
   
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var mediaList: [Media] = [] {
        didSet {
            mediaCollectionView.reloadData()
        }
    }
    
    var page = 1
    var totalPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        /**
         먼저 enum  EndPoint 구조부터 잡기
         1. 장르 UserDefaults 에 저장되어 있는지 확인
         2. 장르가 저장되어 있다면 바로 movieList 호출 아니면 장르 호출 후 movieList 호출
         */
        
        APIManager.shared.callRequest22(endPoint: .genre(language: "ko")) { JSON in
            print(JSON)
        } failure: { error in
            print(error)
        } end: {
            print("종료")
        }

        
        callRequest(page: page)
    }
    
    override func awakeAfter(using coder: NSCoder) -> Any? {
        navigationItem.backButtonDisplayMode = .minimal
        return super.awakeAfter(using: coder)
    }
    
    private func callRequest(page: Int) {
        indicatorView.startAnimating()
        APIManager.shared.callTrendRequest(mediaType: "movie", period: "week", page: page) { JSON in
            
            self.totalPage = JSON["total_pages"].intValue
            for item in JSON["results"].arrayValue {
                var genreIds: [Int] = []
                
                for id in item["genre_ids"].arrayValue {
                    genreIds.append(id.intValue)
                }
                
                let media = Media(
                    id: item["id"].intValue,
                    mediaType: item["media_type"].stringValue,
                    genreIDs: genreIds,
                    title: item["title"].stringValue,
                    content: item["overview"].stringValue,
                    posterPath: item["poster_path"].stringValue,
                    backdropPath: item["backdrop_path"].stringValue,
                    date: item["release_date"].stringValue,
                    vote: item["vote_average"].doubleValue
                )
                self.mediaList.append(media)
            }
            
        } failureHandler: { error in
            print(error)
        } endHandler: {
            self.indicatorView.stopAnimating()
        }
    }
    
    override func designVC() {
        setCollectionViewLayout()
    }
    
    override func configVC() {
        indicatorView.hidesWhenStopped = true
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        mediaCollectionView.prefetchDataSource = self
        
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if mediaList.count - 1 == indexPath.row && page < totalPage {
                page += 1
                callRequest(page: page)
            }
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC else {
            return
        }
        vc.media = mediaList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
