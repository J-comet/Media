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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.addTarget(self, action: #selector(segconChanged), for: .valueChanged)
    }
    
    @objc
    func segconChanged(_ sender: UISegmentedControl) {
        switch Mode(rawValue: sender.selectedSegmentIndex) {
        case .similar:
            print("similar")
            callSimiliar(page: page)
        case .video:
            print("video")
        case .none:
            print("error")
        }
    }
    
    private func callSimiliar(page: Int) {
        indicatorView.startAnimating()
        APIManager.shared.call(
            endPoint: .similar(movieId: String(movieId)),
            responseData: SimilarMovie.self,
            parameterDic: [
                "language" : APILanguage.korea.rawValue,
                "page" : String(page)
            ]
        ) { response in
                dump(response)
            } failure: { error in
                print(error)
            } end: { endUrl in
                print(endUrl)
                self.indicatorView.stopAnimating()
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
