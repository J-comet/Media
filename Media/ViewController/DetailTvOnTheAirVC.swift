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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(tvInfo)
        
        guard let tvInfo else { return }
        
        mainThumbImageView.kf.setImage(with: URL(string: URL.getImg(imgaePath: tvInfo.backdropPath ?? tvInfo.posterPath)))
    }
    
    override func designVC() {
        mainThumbImageView.contentMode = .scaleToFill
    }

    override func configVC() {
        
    }
    
    override func configNavVC() {
        title = "상세 방영 정보"
    }
}

