//
//  MainVC02.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

class TrendVC: CodeBaseViewController {
    
    let mainView = TrendView()
    
    var trendList: [TrendsResult] = []
    var page = 1
    var totalPage = 1
    var movieGenre = UserDefaults.genre
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movieGenre.isEmpty {
            APIManager.shared.call(
                endPoint: .genre,
                responseData: Genres.self,
                parameterDic: ["language": APILanguage.korea.rawValue]
            ) { response in
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
    
    override func configureView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }
    
    private func callTrend(page: Int) {
        //        indicatorView.startAnimating()
        APIManager.shared.call(
            endPoint: .trend(type: .movie, period: "week"),
            responseData: Trends.self,
            parameterDic: [
                "language":APILanguage.korea.rawValue,
                "page":String(page)
            ]
        ) { response in
            self.totalPage = response.totalPages
            self.trendList.append(contentsOf: response.results)
            self.mainView.collectionView.reloadData()
        } failure: { error in
            print(error)
        } end: { endUrl in
            print(endUrl)
            //                self.indicatorView.stopAnimating()
        }
    }
    
}

extension TrendVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as? TrendCollectionViewCell else { return UICollectionViewCell() }
        cell.configCell(row: trendList[indexPath.row])
        return cell
    }
    
    
}
