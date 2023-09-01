//
//  TrendView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit
import BaseFrameWork

class TrendView: BaseView {
    
    weak var delegate: TrendViewProtocol?
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    ).setup { view in
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.prefetchDataSource = self
        view.register(MovieTrendCollectionViewCell.self, forCellWithReuseIdentifier: MovieTrendCollectionViewCell.identifier)
        view.register(TvTrendCollectionViewCell.self, forCellWithReuseIdentifier: TvTrendCollectionViewCell.identifier)
    }
    
    let indicatorView = UIActivityIndicatorView().setup { view in
        view.hidesWhenStopped = true
    }
    
    override func configureView() {
        addSubview(collectionView)
        addSubview(indicatorView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.center.equalToSuperview()
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let count: CGFloat = 1
        let width = UIScreen.main.bounds.width
        return UICollectionViewFlowLayout().collectionViewLayout(
            itemSize: CGSize(width: width / count, height: width / count),
            sectionInset: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0),
            minimumLineSpacing: 20,
            minimumInteritemSpacing: 0)
    }
    
}


extension TrendView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate?.cellForItemAt(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        delegate?.prefetchItemsAt(indexPaths: indexPaths)
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
