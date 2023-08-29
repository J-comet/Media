//
//  ConfigurableView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

protocol ConfigurableView { }
extension ConfigurableView {
    @discardableResult
    func setup(_ block: (_ view: Self) -> Void) -> Self {
        block(self)
        return self
    }
}
extension UIView: ConfigurableView { }
extension UICollectionViewLayout: ConfigurableView { }
