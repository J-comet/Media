//
//  ProfileView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit

class ProfileView: BaseView {
    
    let thumbView = CircleView().setup { view in
        view.backgroundColor = .lightGray
    }
    
    let thumbImageView = UIImageView(frame: .zero).setup { view in
        view.image = UIImage(systemName: "person")
        view.tintColor = .white
    }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    ).setup { view in
        view.showsVerticalScrollIndicator = false
        view.register(ProfileMenuCollectionViewCell.self, forCellWithReuseIdentifier: ProfileMenuCollectionViewCell.identifier)
    }
    
    override func configureView() {
        addSubview(thumbView)
        thumbView.addSubview(thumbImageView)
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        thumbView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        thumbImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(thumbView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let width = UIScreen.main.bounds.width
        return UICollectionViewFlowLayout().collectionViewLayout(
            itemSize: CGSize(width: width, height: 44),
            sectionInset: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0),
            minimumLineSpacing: 8,
            minimumInteritemSpacing: 0)
    }
}
