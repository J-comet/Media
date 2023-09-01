//
//  MainVC02.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit
import BaseFrameWork

protocol TrendViewProtocol: AnyObject {
    func numberOfItemsInSection() -> Int
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func didSelectItemAt(indexPath: IndexPath)
    func prefetchItemsAt(indexPaths: [IndexPath])
}

class TrendVC: BaseViewController {
    
    private let mainView = TrendView()
    private lazy var trendList: [TrendsResult] = [] {
        didSet {
            self.mainView.collectionView.reloadData()
        }
    }
    private var page = 1
    private var totalPage = 1
    private var movieGenre = UserDefaults.movieGenre
    private var tvGenre = UserDefaults.tvGenre
    
    override func loadView() {
        mainView.delegate = self
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavVC()
        
        if movieGenre.isEmpty || tvGenre.isEmpty {
            callGroup()
        } else {
            callTrend(type: .all ,page: page)
        }
    }
    
    override func configureView() {}
    
    // 영화, TV 장르 API 호출
    private func callGroup() {
        APIManager.shared.callGroup { group in
            callGenre(group: group, endPoint: .movieGenre)
            callGenre(group: group, endPoint: .tvGenre)
        } groupStart: {
            mainView.indicatorView.startAnimating()
        } groupNotify: {
            print(UserDefaults.tvGenre)
            self.mainView.indicatorView.stopAnimating()
            self.callTrend(type: .all ,page: self.page)
        }
    }
    
    private func callGenre(group: DispatchGroup, endPoint: Endpoint) {
        APIManager.shared.call(
            group: group,
            endPoint: endPoint,
            responseData: Genres.self,
            parameterDic: ["language": APILanguage.korea.rawValue]
        ) { response in
            print("저장 값 없어서 저장 진행")
            switch endPoint {
            case .movieGenre: UserDefaults.movieGenre = response.genres
            case .tvGenre: UserDefaults.tvGenre = response.genres
            default: print("error")
            }
            
        } failure: { error in
            print(error)
        }
    }
    
    private func configNavVC() {
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle"),
            style: .plain,
            target: self,
            action: #selector(naviBarLeftButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .link
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "TV",
            style: .plain,
            target: self,
            action: #selector(naviBarRightButtonClicked)
        )
        navigationItem.rightBarButtonItem?.tintColor = .link
        
        //        let appearance = UINavigationBarAppearance()
        //        appearance.configureWithOpaqueBackground()
        //        appearance.backgroundColor = UIColor.white
        //
        //        navigationController?.navigationBar.standardAppearance = appearance
        //        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func naviBarLeftButtonClicked(_ sender: UIBarButtonItem) {
        let vc = ProfileVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func naviBarRightButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: TvOnTheAirMainVC.identifier) as? TvOnTheAirMainVC else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func callTrend(type: APIType, page: Int) {
        mainView.indicatorView.startAnimating()
        APIManager.shared.call(
            endPoint: .trend(type: type, period: "week"),
            responseData: Trends.self,
            parameterDic: [
                "language":APILanguage.korea.rawValue,
                "page":String(page)
            ]
        ) { response in
            self.totalPage = response.totalPages
            self.trendList.append(contentsOf: response.results)
//            self.mainView.collectionView.reloadData()
        } failure: { error in
            print(error)
        } end: { endUrl in
            print(endUrl)
            self.mainView.indicatorView.stopAnimating()
        }
    }
    
}

extension TrendVC: TrendViewProtocol {
    
    func numberOfItemsInSection() -> Int {
        return trendList.count
    }
    
    func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = trendList[indexPath.item]
        
        switch row.mediaType {
        case APIType.movie.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieTrendCollectionViewCell.identifier, for: indexPath) as? MovieTrendCollectionViewCell else { return UICollectionViewCell() }
            cell.configCell(row: row)
            return cell
        case APIType.tv.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TvTrendCollectionViewCell.identifier, for: indexPath) as? TvTrendCollectionViewCell else { return UICollectionViewCell() }
            cell.configCell(row: row)
            return cell
        case APIType.person.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleTrendCollectionViewCell.identifier, for: indexPath) as? PeopleTrendCollectionViewCell else { return UICollectionViewCell() }
            cell.configCell(row: row)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailVC.identifier) as? DetailVC else { return }
        vc.trendResult = trendList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func prefetchItemsAt(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if trendList.count - 1 == indexPath.row && page < totalPage {
                page += 1
                callTrend(type: .all, page: page)
            }
        }
    }
}



//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//struct TrendVC_PreViews: PreviewProvider {
//    static var previews: some View {
//        TrendVC().showPreview()
//    }
//}
//#endif
