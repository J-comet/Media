//
//  HeaderSimilarView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import UIKit

protocol HeaderSimilarViewDelegate {
    func youtubeButtonTapped()
}

class HeaderSimilarView: UICollectionReusableView {

    @IBOutlet var bgView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var moveLinkButton: UIButton!
    @IBOutlet var overViewLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    var delegate: HeaderSimilarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designView()
    }
    
    @IBAction func youtubeButtonClicked(_ sender: UIButton) {
        self.delegate?.youtubeButtonTapped()
    }
    
    func configView(row: TrendsResult, videoMovie: VideoMovie) {
        backdropImageView.kf.setImage(
            with: URL(string: URL.getImg(imgaePath: row.backdropPath ?? "")),
          placeholder: nil,
          options: [
            .transition(.fade(0.1))
          ],
          completionHandler: nil
        )
        
        titleLabel.text = row.title
        genreLabel.text = row.getGenre()
        overViewLabel.text = row.overview
        
        moveLinkButton.isHidden = videoMovie.results.isEmpty ? true : false        
    }
    
    func youtubeButtonClicked(clickAction: Selector) {
        moveLinkButton.addTarget(self, action: clickAction, for: .touchUpInside)
    }
    
    func designView() {
        bgView.setLinearGradient(start: .black, end: .white)
        backdropImageView.contentMode = .scaleToFill
        designButton()
        
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        genreLabel.font = .systemFont(ofSize: 14)
        genreLabel.textColor = .white
        genreLabel.numberOfLines = 1
        
        overViewLabel.font = .systemFont(ofSize: 12)
        overViewLabel.textColor = .white
        overViewLabel.numberOfLines = 2
    }
    
    func designButton() {
        var attString = AttributedString("Youtube")
        attString.font = .systemFont(ofSize: 12, weight: .semibold)
        attString.foregroundColor = .white
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        config.image = UIImage(systemName: "play.tv")
        config.imagePadding = 4
        config.imagePlacement = .leading
        config.baseBackgroundColor = .red
        moveLinkButton.configuration = config
    }
    
}
