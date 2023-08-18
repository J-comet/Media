//
//  SegmentMovieVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import UIKit
import SafariServices

class SegmentMovieVC: BaseViewController {
    
    enum Mode: Int {
        case similar
        case video
    }
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var moviewCollectionView: UICollectionView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var movie: TrendsResult?
    var page = 1
    var totalPage = 1
    
    var similar: SimilarMovie?
    var videoMovie: VideoMovie?
    
    var similarList: [SimilarMovieResult] = []
    
    /**
     similar 은 제공되는 이미지가 있지만 video 는 제공되는 이미지가 없음
     두개 동시 호출해서 item 만들기
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.color = .blue
        segmentControl.addTarget(self, action: #selector(segconChanged), for: .valueChanged)
        callGroup()
        
        /**
         1. 컬렉션 헤더뷰를 만들어서 전달 받은 movie 정보의 이미지를 뿌려준다
         2. 컬렉션 헤더뷰를 클릭하면 youtube 로 이동
         3. 세그먼트 눌렀을 때는 스크롤 해당 위치로 이동 similiar 누르면 제일 상단, video 누르면 두번째 헤더 뷰
         */
    }
    
    @objc
    func segconChanged(_ sender: UISegmentedControl) {
        switch Mode(rawValue: sender.selectedSegmentIndex) {
        case .similar:
            print("similar")
        case .video:
            print("video")
        case .none:
            print("error")
        }
    }
    
    private func callGroup() {
        indicatorView.startAnimating()
        let group = DispatchGroup()
        callSimiliar(page: page) { data in
            print("callSimiliar")
            self.similar = data
        } start: {
            group.enter()
        } end: {
            group.leave()
        }
        
        if page == 1 {
            callVideo { data in
                self.videoMovie = data
            } start: {
                group.enter()
            } end: {
                group.leave()
            }
        }
        

        group.notify(queue: .main) {
            print("모두 종료")
            self.indicatorView.stopAnimating()
            
            guard let similarData = self.similar else { return }
            self.totalPage = similarData.totalPages
            self.similarList.append(contentsOf: similarData.results)
            self.moviewCollectionView.reloadData()
        }
    }
    
    private func callSimiliar(
        page: Int,
        success: @escaping (SimilarMovie) -> Void,
        start: () -> Void,
        end: @escaping () -> Void
    ) {
        guard let movie else { return }
        start()
        APIManager.shared.call(
            endPoint: .similar(movieId: String(movie.id)),
            responseData: SimilarMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue,
                "page" : String(page)
            ]
        ) { response in
            success(response)
        } failure: { error in
            print(error)
        } end: { endUrl in
            print(endUrl)
            end()
        }
    }
    
    private func callVideo(
        success: @escaping (VideoMovie) -> Void,
        start: () -> Void,
        end: @escaping () -> Void
    ) {
        guard let movie else { return }
        start()
        APIManager.shared.call(
            endPoint: .movieVideos(movieId: String(movie.id)),
            responseData: VideoMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue
            ]
        ) { response in
            success(response)
        } failure: { error in
            print(error)
        } end: { endUrl in
            print(endUrl)
            end()
        }
    }
    
    override func designVC() {
        designSegControl()
        setCollectionViewLayout()
    }
    
    override func configVC() {
        indicatorView.hidesWhenStopped = true
        moviewCollectionView.delegate = self
        moviewCollectionView.dataSource = self
        moviewCollectionView.prefetchDataSource = self
        
        let nib = UINib(nibName: SimiliarCollectionViewCell.identifier, bundle: nil)
        moviewCollectionView.register(nib, forCellWithReuseIdentifier: SimiliarCollectionViewCell.identifier)
        
        // 헤더뷰에 대한 코드
        moviewCollectionView.register(UINib(nibName: HeaderSimilarView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSimilarView.identifier)
    }
    
    override func configNavVC() {
        title = "비슷한 영화"
    }
    
    func designSegControl() {
        segmentControl.setTitle("Similar", forSegmentAt: Mode.similar.rawValue)
        segmentControl.setTitle("Video", forSegmentAt: Mode.video.rawValue)
    }
    
    private func setCollectionViewLayout() {
        moviewCollectionView.showsVerticalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let sectionSpacing: CGFloat = 24
        let count: CGFloat = 3
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        
        layout.itemSize = CGSize(width: width / count, height: (width / count) * 1.5)
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.6)
        moviewCollectionView.collectionViewLayout = layout
    }
    
}

extension SegmentMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if similarList.count - 1 == indexPath.row && page < totalPage {
                page += 1
                callGroup()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimiliarCollectionViewCell.identifier, for: indexPath) as? SimiliarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(row: similarList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSimilarView.identifier, for: indexPath) as? HeaderSimilarView else { return UICollectionReusableView() }
            
            if let movie {
                view.configView(row: movie)
                view.delegate = self
            }
            
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

extension SegmentMovieVC: HeaderSimilarViewDelegate {
    func youtubeButtonTapped() {
        guard let videoMovie else { return }
        let youtubeUrl = NSURL(string: URL.getYoutubeLink(key: videoMovie.results[0].key)) as? URL
        guard let youtubeUrl else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: youtubeUrl)
        self.present(safariView, animated: true, completion: nil)
    }
    
}
