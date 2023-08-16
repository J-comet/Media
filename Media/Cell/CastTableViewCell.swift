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
    
    private var workItem: DispatchWorkItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        clear()
    }
    
    func clear() {
        thumbImageView.image = UIImage(systemName: "placeholdertext.fill")
        workItem?.cancel()
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
        let char = row.character
        let castID = row.castID
        
        if let char, let castID {
            infoLabel.text = char + "/ No. \(castID)"
        } else {
            if let char {
                infoLabel.text = char
            }
        }
        
        guard let profilePath = row.profilePath else {
            return
        }
        let url = URL(string: URL.imgURL + profilePath)
        let globalQueue = DispatchQueue.global()

        workItem = DispatchWorkItem {
            if let url {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.thumbImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        if let workItem {
            globalQueue.async(execute: workItem)
        }
    }
}
