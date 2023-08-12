//
//  MediaCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    
    typealias T = Media
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    
    @IBOutlet var guideVoteAverLabel: UILabel!
    @IBOutlet var voteContainerView: UIView!
    @IBOutlet var opacityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }

    func designCell() {
        guideVoteAverLabel.isHidden = true
        voteContainerView.isHidden = true
        opacityView.isHidden = true
        
        dateLabel.font = .systemFont(ofSize: 11, weight: .light)
        dateLabel.textColor = .darkGray
        typeLabel.font = .boldSystemFont(ofSize: 16)
        typeLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .black
        contentLabel.font = .systemFont(ofSize: 12)
        contentLabel.textColor = .darkGray
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView.layer.shadowRadius = 5
        containerView.layer.masksToBounds = false
        
        voteLabel.textColor = .black
        voteLabel.font = .systemFont(ofSize: 13, weight: .light)
        
        thumbImageView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        thumbImageView.layer.cornerRadius = 10
        thumbImageView.contentMode = .scaleAspectFill
    }
    
    func configureCell(row: Media) {
        
        dateLabel.text = row.date
        typeLabel.text = row.getCategory(type: row.mediaType)
        titleLabel.text = row.title
        contentLabel.text = row.content
        voteLabel.text = row.getVoteAverage(vote: row.vote)
        
        let url = URL(string: URL.imgURL + row.backdropPath)
        if let url {
            DispatchQueue.global().async {
                let data = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.thumbImageView.image = UIImage(data: data)
                    self.guideVoteAverLabel.isHidden = false
                    self.voteContainerView.isHidden = false
                    self.opacityView.isHidden = false
                }
            }
        }
    }
}
