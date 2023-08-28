//
//  MainVC02.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

class TrendVC: CodeBaseViewController {
    
    let mainView = TrendView()
    
    override func loadView() {
        view = mainView
    }
    
    override func configureView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }

}

extension TrendVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as? TrendCollectionViewCell else { return UICollectionViewCell() }
        cell.thumbImageView.backgroundColor = .blue
        return cell
    }
    
    
}
