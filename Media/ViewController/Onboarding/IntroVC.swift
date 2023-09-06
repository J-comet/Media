//
//  IntroVC.swift
//  Media
//
//  Created by 장혜성 on 2023/08/26.
//

import UIKit
import SnapKit

class IntroVC: UIViewController {
    
    let introLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    init(bgColor: UIColor, description: String) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = bgColor
        self.introLabel.text = description
        print(description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(introLabel)
        introLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

}
