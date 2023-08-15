//
//  DetailVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class DetailVC: BaseViewController {

    @IBOutlet var tableHeaderContainerView: UIView!
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var guideOverViewLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var castTableView: UITableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var trendResult: TrendsResult?
    var isContentOpen = false
    var castList: [Cast] = [] {
        didSet {
            castTableView.reloadData()
        }
    }
    
    var baseChangeHeight = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            let defaultLabelHeight = self.contentLabel.frame.size.height / 2
            let openLabelHeight = defaultLabelHeight * CGFloat(self.contentLabel.countLines())
            
            print(defaultLabelHeight)
            print(openLabelHeight)
            self.baseChangeHeight = openLabelHeight - self.contentLabel.frame.size.height
            print(self.baseChangeHeight)
        }
    }
    
    @IBAction func overViewMoreButtonClicked(_ sender: UIButton) {
        isContentOpen.toggle()
        contentLabel.numberOfLines = isContentOpen ? 0 : 2
        let image = isContentOpen ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        moreButton.setImage(image, for: .normal)

        guard let headerView = castTableView.tableHeaderView else { return }

        headerView.frame = isContentOpen ? CGRectMake(0, 0, self.view.frame.size.width , headerView.frame.size.height + baseChangeHeight) :
        CGRectMake(0, 0, self.view.frame.size.width , headerView.frame.size.height - baseChangeHeight)

        castTableView.tableHeaderView = headerView
        castTableView.layoutIfNeeded()
    }
    
    func callRequest(id: String) {
        indicatorView.startAnimating()
        APIManager.shared.callCreditRequest(
            mediaType: "movie",id: id) { JSON in
                for item in JSON["cast"].arrayValue {
                    let cast = Cast(
                        id: item["id"].intValue,
                        name: item["name"].stringValue,
                        characterName: item["character"].stringValue,
                        castId: item["cast_id"].intValue,
                        profilePath: item["profile_path"].stringValue
                    )
                    self.castList.append(cast)
                }
                
            } failureHandler: { error in
                print(error)
            } endHandler: {
                self.indicatorView.stopAnimating()
            }
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
        guideOverViewLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        guideOverViewLabel.textColor = .lightGray
        guideOverViewLabel.text = "OverView"
        backdropImageView.contentMode = .scaleAspectFill
        posterImageView.contentMode = .scaleAspectFit
    }
    
    override func configVC() {
        castTableView.rowHeight = 70
        castTableView.dataSource = self
        castTableView.delegate = self
        
        let nib = UINib(nibName: CastTableViewCell.identifier, bundle: nil)
        castTableView.register(nib, forCellReuseIdentifier: CastTableViewCell.identifier)
        
        guard let trendResult else { return }
        
        callRequest(id: "\(trendResult.id)")

        titleLabel.text = trendResult.title
        contentLabel.text = trendResult.overview
        
        moreButton.isHidden = contentLabel.countLines() >= 3 ? false : true
        
        let backdropUrl = URL(string: URL.imgURL + trendResult.backdropPath)
        let posterUrl = URL(string: URL.imgURL + trendResult.posterPath)
    
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

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    
    // 테이블뷰 섹션 텍스트 스타일
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.textColor = .lightGray
        header.textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Cast" : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier) as? CastTableViewCell else { return UITableViewCell() }
        cell.configureCell(row: castList[indexPath.row])
        return cell
    }
    
}
