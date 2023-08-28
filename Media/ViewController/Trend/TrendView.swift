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
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let count: CGFloat = 1
        let width = UIScreen.main.bounds.width
        return UICollectionViewFlowLayout().collectionViewLayout(
            itemSize: CGSize(width: width / count, height: width / count),
            sectionInset: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0),
            minimumLineSpacing: 20,
            minimumInteritemSpacing: 0)
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
