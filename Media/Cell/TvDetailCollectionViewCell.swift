//
//  TvDetailCollectionViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/17.
//

import UIKit

class TvDetailCollectionViewCell: UICollectionViewCell, BaseCellProtocol {
    typealias T = String
    
    @IBOutlet var thumbImgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }

    func designCell() {
        thumbImgView.contentMode = .scaleAspectFit
        thumbImgView.backgroundColor = .cyan
    }
    
    func configureCell(row: String) {
        titleLabel.text = row
    }
}
