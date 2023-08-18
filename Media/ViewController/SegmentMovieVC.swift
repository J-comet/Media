//
//  SegmentMovieVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import UIKit

class SegmentMovieVC: BaseViewController {
    
    enum Mode: Int {
        case similar
        case video
    }
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var moviewCollectionView: UICollectionView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var movieId = 671
    var page = 1
    
    /**
     similar 은 제공되는 이미지가 있지만 video 는 제공되는 이미지가 없음
     두개 동시 호출해서 item 만들기
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.color = .blue
        indicatorView.hidesWhenStopped = true
        segmentControl.addTarget(self, action: #selector(segconChanged), for: .valueChanged)
        callGroup()
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
        } start: {
            group.enter()
        } end: {
            group.leave()
        }
        
        callVideo { data in
            print("callVideo")
        } start: {
            group.enter()
        } end: {
            group.leave()
        }

        group.notify(queue: .main) {
            print("모두 종료")
            self.indicatorView.stopAnimating()
        }
    }
    
    private func callSimiliar(
        page: Int,
        success: @escaping (SimilarMovie) -> Void,
        start: () -> Void,
        end: @escaping () -> Void
    ) {
        start()
        APIManager.shared.call(
            endPoint: .similar(movieId: String(movieId)),
            responseData: SimilarMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue,
                "page" : String(page)
            ]
        ) { response in
            success(response)
            //                dump(response)
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
        start()
        APIManager.shared.call(
            endPoint: .movieVideos(movieId: String(movieId)),
            responseData: VideoMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue
            ]
        ) { response in
            success(response)
            //                dump(response)
        } failure: { error in
            print(error)
        } end: { endUrl in
            print(endUrl)
            end()
        }
    }
    
    override func designVC() {
        designSegControl()
    }
    
    override func configVC() {
        
    }
    
    func designSegControl() {
        segmentControl.setTitle("Similar", forSegmentAt: Mode.similar.rawValue)
        segmentControl.setTitle("Video", forSegmentAt: Mode.video.rawValue)
    }
    
}
