//
//  ProfileMenuCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit

class ProfileMenuCollectionViewCell: BaseCollectionViewCell<ProfileMenu> {
    
    let titleLabel = UILabel().setup { view in
        view.textColor = .black
        view.font = .systemFont(ofSize: 16)
    }
    
    let contentLabel = UILabel().setup { view in
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
    }
    
    let lineView = UIView().setup { view in
        view.backgroundColor = .systemGray5
    }
    
    override func configureView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(lineView)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.25)
        }
                
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentLabel)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func configCell(row: ProfileMenu) {
        titleLabel.text = row.type.title
        contentLabel.text = row.content.isEmpty ? row.type.placeHolder : row.content
    }
}
