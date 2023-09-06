//
//  TVOnTheAirCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/16.
//

import UIKit
import Kingfisher

class TVOnTheAirCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    typealias T = TvOnTheAirResult
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }

    func designCell() {
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    func configureCell(row: TvOnTheAirResult) {
//        thumbImageView.kf.indicatorType = .activity
        titleLabel.text = row.originalName
        thumbImageView.kf.setImage(
            with: URL(string: URL.getImg(imgaePath: row.backdropPath ?? row.posterPath)),
          placeholder: nil,
          options: [
            .transition(.fade(0.1))
          ],
          completionHandler: nil
        )
    }
}
