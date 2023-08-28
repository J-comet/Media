//
//  UIViewCollectionVIewFlowLayout+Extension.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    func collectionViewLayout(
        itemSize: CGSize,
        sectionInset: UIEdgeInsets,
        minimumLineSpacing: CGFloat,
        minimumInteritemSpacing: CGFloat
    ) -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout().setup { view in
            view.itemSize = itemSize
            view.sectionInset = sectionInset
            view.minimumLineSpacing = minimumLineSpacing
            view.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }

}
