//
//  OnboardingNextButton.swift
//  Media
//
//  Created by 장혜성 on 2023/08/26.
//

import UIKit

class OnboardingNextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView(text: "Next")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(text: String) {
        var attString = AttributedString(text.uppercased())
        attString.font = .systemFont(ofSize: 14, weight: .medium)
        attString.foregroundColor = .white
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseBackgroundColor = .black
        configuration = config
    }
}
