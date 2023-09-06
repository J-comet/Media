//
//  ProfileEditView.swift
//  Media
//
//  Created by 장혜성 on 2023/08/29.
//

import UIKit
import BaseFrameWork

class ProfileEditView: BaseView {
    
    override var isShowDeinit: Bool { true }
    
    let guideLabel = UILabel().setup { view in
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .darkGray
    }
    
    let editTextField = UITextField().setup { view in
        view.borderStyle = .none
        view.textColor = .black
        view.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    let lineView = UIView().setup { view in
        view.backgroundColor = .black
    }
    
    override func configureView() {
        addSubview(guideLabel)
        addSubview(editTextField)
        addSubview(lineView)
    }
    
    override func setConstraints() {
        guideLabel.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        editTextField.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(8)
            $0.leading.width.equalTo(guideLabel)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(editTextField.snp.bottom).offset(4)
            $0.leading.width.equalTo(guideLabel)
            $0.height.equalTo(1)
        }
    }
}
