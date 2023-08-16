//
//  TvOnTheAirMainVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/16.
//

import UIKit

class TvOnTheAirMainVC: BaseViewController {
    
    @IBOutlet var tvCollectionView: UICollectionView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var tvList: [TvOnTheAirResult] = [] {
        didSet {
            tvCollectionView.reloadData()
        }
    }
    var page = 1
    var totalPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callTvOnTheAir(page: page)
    }
    
    override func awakeAfter(using coder: NSCoder) -> Any? {
        navigationItem.backButtonDisplayMode = .minimal
        return super.awakeAfter(using: coder)
    }
    
    func callTvOnTheAir(page: Int) {
        indicatorView.startAnimating()
        APIManager.shared.call(
            endPoint: .tvOnTheAir(language: APILaunage.KOREA.rawValue, page: String(page)),
            responseData: TvOnTheAir.self) { response in
                self.totalPage = response.totalPages
                self.tvList.append(contentsOf: response.results)
            } failure: { error in
                print(error)
            } end: { endUrl in
                self.indicatorView.stopAnimating()
            }
    }
    
    private func setCollectionViewLayout() {
        tvCollectionView.showsVerticalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let count: CGFloat = 2
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        
        layout.itemSize = CGSize(width: width / count, height: (width / count) * 1.2)
        layout.sectionInset = UIEdgeInsets(top: 20, left: spacing, bottom: 20, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        tvCollectionView.collectionViewLayout = layout
    }
    
    override func designVC() {
        setCollectionViewLayout()
    }
    
    override func configNavVC() {
        title = "방영 중인 TV"
    }
    
    override func configVC() {
        indicatorView.hidesWhenStopped = true
        tvCollectionView.delegate = self
        tvCollectionView.dataSource = self
        tvCollectionView.prefetchDataSource = self
        
        let nib = UINib(nibName: TVOnTheAirCollectionViewCell.identifier, bundle: nil)
        tvCollectionView.register(nib, forCellWithReuseIdentifier: TVOnTheAirCollectionViewCell.identifier)
    }
    
}

extension TvOnTheAirMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if tvList.count - 1 == indexPath.row && page < totalPage {
                page += 1
                callTvOnTheAir(page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVOnTheAirCollectionViewCell.identifier, for: indexPath) as? TVOnTheAirCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(row: tvList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailTvOnTheAirVC.identifier) as? DetailTvOnTheAirVC else {
            return
        }
        vc.tvInfo = tvList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
