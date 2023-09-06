//
//  RoundImageView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit


class CircleView: ClickableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    func configureView() {
        clipsToBounds = true
    }
}
