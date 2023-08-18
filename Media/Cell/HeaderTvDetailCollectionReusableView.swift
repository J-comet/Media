//
//  HeaderTvDetailCollectionReusableView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/17.
//

import UIKit

class HeaderTvDetailCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet var headerTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        designView()
    }
    
    func designView() {
        headerTitleLabel.textColor = .lightGray
        headerTitleLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    func configView(row: Season) {
        
        headerTitleLabel.text = "시즌 [\(row.seasonNumber)]"
    }
}
