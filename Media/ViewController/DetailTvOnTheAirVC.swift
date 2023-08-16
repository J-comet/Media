//
//  DetailTvOnTheAirVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/16.
//

import UIKit

class DetailTvOnTheAirVC: BaseViewController {

    @IBOutlet var mainThumbImageView: UIImageView!
    @IBOutlet var detailCollectionView: UICollectionView!
    
    var tvInfo: TvOnTheAirResult?
    
    var seasonList: [Season] = []
    var episodeList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dump(tvInfo)
        
        guard let tvInfo else { return }
        
        mainThumbImageView.kf.setImage(with: URL(string: URL.getImg(imgaePath: tvInfo.backdropPath ?? tvInfo.posterPath)))
        callTvDetail(id: tvInfo.id)
    }
    
    func callTvDetail(id: Int) {
        print("id = ",id)
//        APIManager.shared.call(endPoint: .tvDetail(sereiesId: String(id)), responseData: TvDetail.self) { response in
//            print(response)
//        } failure: { error in
//            print("ERROR = ",error)
//        } end: { _ in
//
//        }
        
        APIManager.shared.call(endPoint: .tvDetail(sereiesId: String(id))) { JSON in
            for item in JSON["seasons"].arrayValue {
                let season = Season(
                    airDate: item["air_date"].stringValue,
                    episodeCount: item["episode_count"].intValue,
                    id: item["id"].intValue,
                    name: item["name"].stringValue,
                    overview: item["overview"].stringValue,
                    posterPath: item["poster_path"].stringValue,
                    seasonNumber: item["season_number"].intValue,
                    voteAverage: item["vote_average"].doubleValue
                )
                self.seasonList.append(season)
            }
            
            print(self.seasonList)
            
        } failure: { error in
            print("ERROR = ",error)
        } end: { _ in

        }
    }
    
    private func setCollectionViewLayout() {
        detailCollectionView.showsVerticalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let count: CGFloat = 1
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        
        layout.itemSize = CGSize(width: width / count, height: (width / count) * 1.2)
        layout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        detailCollectionView.collectionViewLayout = layout
    }
    
    override func designVC() {
        mainThumbImageView.contentMode = .scaleAspectFill
        setCollectionViewLayout()
    }

    override func configVC() {
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
    }
    
    override func configNavVC() {
        title = "상세 방영 정보"
    }
}

extension DetailTvOnTheAirVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return seasonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

