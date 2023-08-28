//
//  TrendCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import UIKit

class TrendCollectionViewCell: BaseCollectionViewCell<TrendsResult> {
    
    let dateLabel = UILabel().setup { view in
        view.font = .systemFont(ofSize: 11, weight: .light)
        view.textColor = .darkGray
    }
    
    let typeLabel = UILabel().setup { view in
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .black
        view.numberOfLines = 1
    }
    
    let containerView = UIView().setup { view in
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 5
        view.layer.masksToBounds = false
    }
    
    let thumbImageView = UIImageView().setup { view in
        view.contentMode = .scaleToFill
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    let opacityView = UIView().setup { view in
        view.isHidden = true
        view.backgroundColor = UIColor(.black).withAlphaComponent(0.4)
    }
    
    let voteContainerView = UIView().setup { view in
        view.isHidden = false
    }
    
    let guideVoteLabel = UILabel().setup { view in
        view.text = "평점"
        view.textAlignment = .center
        view.textColor = .white
        view.backgroundColor = .link
        view.font = .systemFont(ofSize: 13, weight: .light)
    }
    
    let voteLabel = UILabel().setup { view in
        view.textAlignment = .center
        view.backgroundColor = .white
        view.textColor = .black
        view.font = .systemFont(ofSize: 13, weight: .light)
    }
    
    override func configCell(row: TrendsResult) {
        dateLabel.text = row.getReleaseDate()
        typeLabel.text = row.getGenre()
        voteLabel.text = row.getVoteAverage()
        
        let url = URL(string: URL.getImg(imgaePath: row.backdropPath))
        if let url {
            thumbImageView.kf.setImage(
                with: url,
              placeholder: nil,
              options: [
                .transition(.fade(0.1))
              ],
              completionHandler: nil
            )
            
//            self.guideVoteAverLabel.isHidden = false
            voteContainerView.isHidden = false
            opacityView.isHidden = false
        }
    }
    
    override func configureView() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(containerView)
        
        containerView.addSubview(thumbImageView)
        containerView.addSubview(opacityView)
        containerView.addSubview(voteContainerView)
        
        voteContainerView.addSubview(guideVoteLabel)
        voteContainerView.addSubview(voteLabel)
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        containerView.backgroundColor = .cyan
        containerView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        thumbImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        opacityView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(thumbImageView)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        voteContainerView.backgroundColor = .yellow
        voteContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.centerY.equalTo(opacityView)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        guideVoteLabel.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.leading.verticalEdges.equalToSuperview()
        }
        
        voteLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(38)
            $0.leading.equalTo(guideVoteLabel.snp.trailing)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    
    
}
