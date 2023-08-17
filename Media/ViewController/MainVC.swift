//
//  MainVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit
import Alamofire

class MainVC: BaseViewController {
   
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var trendList: [TrendsResult] = [] {
        didSet {
            mediaCollectionView.reloadData()
        }
    }
    
    var page = 1
    var totalPage = 1
    var movieGenre = UserDefaults.genre
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        /**
         먼저 enum  EndPoint 구조부터 잡기
         1. 장르 UserDefaults 에 저장되어 있는지 확인
         2. 장르가 저장되어 있다면 바로 movieList 호출 아니면 장르 호출 후 movieList 호출
         */
        if movieGenre.isEmpty {
            APIManager.shared.call(endPoint: .genre(language: .korea), responseData: Genres.self) { response in
                print("저장 값 없어서 저장 진행")
                UserDefaults.genre = response.genres
                self.callTrend(page: self.page)
                
            } failure: { error in
                print(error)
            } end: { endUrl in
                print(endUrl)
            }
        } else {
            callTrend(page: page)
        }
    }
    
    override func awakeAfter(using coder: NSCoder) -> Any? {
        navigationItem.backButtonDisplayMode = .minimal
        return super.awakeAfter(using: coder)
    }
    
    private func callTrend(page: Int) {
        indicatorView.startAnimating()
        APIManager.shared.call(
            endPoint: .trend(language: .korea, type: .movie, period: "week", page: String(page)),
            responseData: Trends.self) { response in
                self.totalPage = response.totalPages
                self.trendList.append(contentsOf: response.results)
            } failure: { error in
                print(error)
            } end: { endUrl in
                print(endUrl)
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
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "magnifyingglass"),
//            style: .plain,
//            target: self,
//            action: #selector(naviBarRightButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "TV",
            style: .plain,
            target: self,
            action: #selector(naviBarRightButtonClicked)
        )
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
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: TvOnTheAirMainVC.identifier) as? TvOnTheAirMainVC else { return }
        navigationController?.pushViewController(vc, animated: true)
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
            if trendList.count - 1 == indexPath.row && page < totalPage {
                page += 1
                callTrend(page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(row: trendList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC else {
            return
        }
        vc.trendResult = trendList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
