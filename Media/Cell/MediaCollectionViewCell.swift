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

    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }

    func designCell() {
        dateLabel.font = .systemFont(ofSize: 11, weight: .light)
        dateLabel.textColor = .systemGray4
        typeLabel.font = .boldSystemFont(ofSize: 14)
        typeLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .black
        contentLabel.font = .systemFont(ofSize: 12)
        contentLabel.textColor = .systemGray4
        
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView.layer.shadowRadius = 5
        containerView.layer.masksToBounds = false
    }
    
    func configureCell(row: Media) {
        
    }
}
