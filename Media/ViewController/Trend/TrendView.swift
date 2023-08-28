//
//  TrendView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

class TrendView: BaseView {
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    ).setup { view in
        view.showsVerticalScrollIndicator = false
        view.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: TrendCollectionViewCell.identifier)
    }
    
    override func configureView() {
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let count: CGFloat = 1
        let width = UIScreen.main.bounds.width
        return UICollectionViewFlowLayout().collectionViewLayout(
            count: count,
            width: width,
            itemSize: CGSize(width: width / count, height: width / count),
            sectionInset: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0),
            minimumLineSpacing: 20,
            minimumInteritemSpacing: 0)
    }
}
