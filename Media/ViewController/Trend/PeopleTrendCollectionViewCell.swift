//
//  PeopleTrendCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/09/01.
//

import UIKit
import BaseFrameWork
import SnapKit

class PeopleTrendCollectionViewCell: BaseCollectionViewCell<TrendsResult> {
    
    let thumbImageView = UIImageView().setup { view in
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .blue
    }
    
    let rightContainerView = UIView().setup { view in
        view.backgroundColor = .yellow
    }
    
    let nameLabel = UILabel().setup { view in
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .black
    }
    
    let knownForLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 13, weight: .light)
        view.textColor = .gray
        view.numberOfLines = 0
        view.lineBreakMode = .byCharWrapping
    }
    
    override func configureView() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(rightContainerView)
        
        rightContainerView.addSubview(nameLabel)
        rightContainerView.addSubview(knownForLabel)
    }
    
    override func setConstraints() {
        
        thumbImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.verticalEdges.equalToSuperview()
        }
        
        rightContainerView.snp.makeConstraints {
            $0.leading.equalTo(thumbImageView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        nameLabel.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview().inset(4)
        }
        
        knownForLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(nameLabel)
            $0.bottom.lessThanOrEqualTo(8)
        }
    }
    
    override func configCell(row: TrendsResult) {
        nameLabel.text = row.getTitle()
        knownForLabel.text = row.getKnownFor()
        
        let url = URL(string: URL.getImg(imgaePath: row.profilePath ?? ""))
        if let url {
            thumbImageView.kf.setImage(
                with: url,
              placeholder: nil,
              options: [
                .transition(.fade(0.1))
              ],
              completionHandler: nil
            )
        }
    }
    
}
