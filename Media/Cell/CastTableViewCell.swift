//
//  CastTableViewCell.swift
//  Media
//
//  Created by 장혜성 on 2023/08/13.
//

import UIKit

class CastTableViewCell: UITableViewCell, BaseCellProtocol {
    typealias T = Cast
    
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = UIImage(systemName: "person.fill.questionmark")
    }
    
    func designCell() {
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.textColor = .black
        infoLabel.font = .systemFont(ofSize: 13, weight: .light)
        infoLabel.textColor = .systemGray5
        
        thumbImageView.layer.cornerRadius = 8
        thumbImageView.contentMode = .scaleAspectFit
    }
    
    func configureCell(row: Cast) {
        nameLabel.text = row.name
        infoLabel.text = row.characterName + " / \(row.castId)"
        
        let url = URL(string: URL.imgURL + row.profilePath)
        if let url {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                guard let data else {
                    DispatchQueue.main.async {
                        self.thumbImageView.image = UIImage(systemName: "person.fill.questionmark")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.thumbImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
