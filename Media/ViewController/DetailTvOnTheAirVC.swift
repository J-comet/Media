//
//  DetailTvOnTheAirVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/16.
//

import UIKit

class DetailTvOnTheAirVC: BaseStoryboardViewController {

    @IBOutlet var mainThumbImageView: UIImageView!
    @IBOutlet var detailCollectionView: UICollectionView!
    
    var tvInfo: TvOnTheAirResult?
    
    var seasonList: [Season] = []
    var episodeList: [String] = ["1","2","3"]
    
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
            
            dump(self.seasonList)
            
            // TODO - 두개 동시에 끝났을 때 reloadData
            self.detailCollectionView.reloadData()
            
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
        
        layout.itemSize = CGSize(width: width / count, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        detailCollectionView.collectionViewLayout = layout
    }
    
    override func designVC() {
        mainThumbImageView.contentMode = .scaleAspectFill
        setCollectionViewLayout()
    }

    override func configVC() {
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
        
        let nib = UINib(nibName: TvDetailCollectionViewCell.identifier, bundle: nil)
        detailCollectionView.register(nib, forCellWithReuseIdentifier: TvDetailCollectionViewCell.identifier)
        
        // 헤더뷰에 대한 코드
        detailCollectionView.register(UINib(nibName: HeaderTvDetailCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTvDetailCollectionReusableView.identifier)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TvDetailCollectionViewCell.identifier, for: indexPath) as? TvDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(row: episodeList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTvDetailCollectionReusableView.identifier, for: indexPath) as? HeaderTvDetailCollectionReusableView else { return UICollectionReusableView() }
            view.configView(row: seasonList[indexPath.section])
            return view
        } else {
            return UICollectionReusableView()
        }
    }
    
}

