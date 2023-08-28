//
//  TrendCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

class TrendCollectionViewCell: BaseCollectionViewCell {
    let thumbImageView = {
        let view = UIImageView()
        view.backgroundColor = .cyan
        view.contentMode = .scaleToFill
        return view
    }()
    
    override func configureView() {
        contentView.addSubview(thumbImageView)
    }
    
    override func setConstraints() {
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
