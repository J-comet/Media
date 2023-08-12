//
//  DetailVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class DetailVC: BaseViewController {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var guideOverViewLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    
    var media: Media?
    
    var isContentOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(media)
    }
    
    @IBAction func overViewMoreButtonClicked(_ sender: UIButton) {
        isContentOpen.toggle()
        contentLabel.numberOfLines = isContentOpen ? 0 : 2
        let image = isContentOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        moreButton.setImage(image, for: .normal)
    }
    
    func designTitle() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
    }
    
    func designContent() {
        contentLabel.numberOfLines = 2
        contentLabel.textColor = .black
        contentLabel.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    override func designVC() {
        designTitle()
        designContent()
        guideOverViewLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        guideOverViewLabel.textColor = .darkGray
        guideOverViewLabel.text = "OverView"
        backdropImageView.contentMode = .scaleAspectFill
        posterImageView.contentMode = .scaleAspectFit
    }
    
    override func configVC() {
        guard let media else { return }
        
        titleLabel.text = media.title
        contentLabel.text = media.content
        
        moreButton.isHidden = contentLabel.countLines() >= 3 ? false : true
        
        let backdropUrl = URL(string: URL.imgURL + media.backdropPath)
        let posterUrl = URL(string: URL.imgURL + media.posterPath)
    
        if let backdropUrl, let posterUrl {
            DispatchQueue.global().async {
                let backDropData = try! Data(contentsOf: backdropUrl)
                let posterData = try! Data(contentsOf: posterUrl)
                DispatchQueue.main.async {
                    self.backdropImageView.image = UIImage(data: backDropData)
                    self.posterImageView.image = UIImage(data: posterData)
                }
            }
        }
    }
    
    override func configNavVC() {
        title = "출연/제작"
        navigationController?.navigationBar.tintColor = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // This will alter the navigation bar title appearance
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black] //alter to fit your needs
        appearance.titleTextAttributes = titleAttribute
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}
