//
//  ClickableView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit

class ClickableView: UIView {
    var onClick: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClick()
    }
}
