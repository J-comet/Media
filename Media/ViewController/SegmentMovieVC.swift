//
//  SegmentMovieVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import UIKit
import SafariServices

class SegmentMovieVC: BaseStoryboardViewController {
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var moviewCollectionView: UICollectionView!
    
    var movie: TrendsResult?
    var page = 1
    var totalPage = 1
    
    var similar: SimilarMovie?
    var videoMovie: VideoMovie?
    
    var similarList: [SimilarMovieResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.color = .blue
        callGroup()
    }

    private func callGroup() {
        APIManager.shared.callGroup { group in
            guard let movie else { return }
            callSimiliar(group: group, movieId: String(movie.id))
            if page == 1 {
                callVideo(group: group, movieId: String(movie.id))
            }
        } groupStart: {
            indicatorView.startAnimating()
        } groupNotify: {
            self.indicatorView.stopAnimating()
            guard let similarData = self.similar else { return }
            self.totalPage = similarData.totalPages
            self.similarList.append(contentsOf: similarData.results)
            self.moviewCollectionView.reloadData()
            
            if self.page == 1 {
                self.moviewCollectionView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    private func callSimiliar(group: DispatchGroup, movieId: String) {
        APIManager.shared.call(
            group: group,
            endPoint: .similar(movieId: movieId),
            responseData: SimilarMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue,
                "page" : String(page)
            ]
        ) { response in
                self.similar = response
        } failure: { error in
            print(error)
        }
    }
    
    private func callVideo(group: DispatchGroup, movieId: String) {
        APIManager.shared.call(
            group: group,
            endPoint: .movieVideos(movieId: movieId),
            responseData: VideoMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue
            ]
        ) { response in
                self.videoMovie = response
        } failure: { error in
            print(error)
        }
    }
    
    func showSheet(videoMovieResult: [VideoMovieResult], handler: ((UIAlertAction) -> Void)? = nil) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        videoMovieResult.enumerated().forEach { idx, result in
            let action = UIAlertAction(title: "Youtube [\(idx + 1)]", style: .default) { _ in
                let youtubeUrl = NSURL(string: URL.getYoutubeLink(key: result.key)) as? URL
                guard let youtubeUrl else { return }
                let safariView: SFSafariViewController = SFSafariViewController(url: youtubeUrl)
                self.present(safariView, animated: true, completion: nil)
            }
            sheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        sheet.addAction(cancelAction)
        present(sheet, animated: true)
    }
    
    override func designVC() {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 현재페이지 선택한 아이템의 movieId 로 다시 api 호출 화면 갱신
        let row = similarList[indexPath.row]
        print("선택한 영화 =", row.id)
        // 거의 비슷한 데이터를 copy 하는 느낌? 같은 구조체였으면..
        let currentMovie = TrendsResult(
            adult: row.adult, backdropPath: row.backdropPath ?? "", id: row.id,
            title: row.title, originalLanguage: row.originalLanguage,
            originalTitle: row.originalTitle, overview: row.overview,
            posterPath: row.posterPath ?? "", mediaType: "movie", genreIDS: row.genreIDS,
            popularity: row.popularity, releaseDate: row.releaseDate,
            video: row.video, voteAverage: row.voteAverage, voteCount: row.voteCount
        )
        similarList.removeAll()
        page = 1
        movie = currentMovie
        callGroup()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSimilarView.identifier, for: indexPath) as? HeaderSimilarView else { return UICollectionReusableView() }
            
            if let movie, let videoMovie {
                view.configView(row: movie, videoMovie: videoMovie)
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
        
        if videoMovie.results.count == 1 {
            let youtubeUrl = NSURL(string: URL.getYoutubeLink(key: videoMovie.results[0].key)) as? URL
            guard let youtubeUrl else { return }
            let safariView: SFSafariViewController = SFSafariViewController(url: youtubeUrl)
            self.present(safariView, animated: true, completion: nil)
        } else {
            showSheet(videoMovieResult: videoMovie.results)
        }
        
        
        // TODO : videoMovie.results 가 2개이상이면 어떻게 보여줄지?
//        let youtubeUrl = NSURL(string: URL.getYoutubeLink(key: videoMovie.results[0].key)) as? URL
//        guard let youtubeUrl else { return }
//        let safariView: SFSafariViewController = SFSafariViewController(url: youtubeUrl)
//        self.present(safariView, animated: true, completion: nil)
    }
    
}
