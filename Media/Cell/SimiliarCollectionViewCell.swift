//
//  SimiliarCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import UIKit
import Kingfisher

class SimiliarCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    typealias T = SimilarMovieResult

    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }

    func designCell() {
        thumbImageView.backgroundColor = .lightGray
        thumbImageView.layer.cornerRadius = 12
        thumbImageView.contentMode = .scaleAspectFill
        titleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
    }
    
    func configureCell(row: SimilarMovieResult) {
        titleLabel.text = row.title
        guard let path = row.backdropPath else { return }
        thumbImageView.kf.indicatorType = .activity
        thumbImageView.kf.setImage(
            with: URL(string: URL.getImg(imgaePath: path)),
          placeholder: nil,
          options: [
            .transition(.fade(0.1))
          ],
          completionHandler: nil
        )
    }
}
