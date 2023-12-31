//
//  BaseViewController.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class BaseStoryboardViewController: UIViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designVC()
        configVC()
        configNavVC()
        configDefaultBackgroundColor()
    }
    
    private func configDefaultBackgroundColor() {
        self.view.backgroundColor = .white
    }
    
    func designVC() {}
    
    func configVC() {}
    
    func configNavVC() {}
}
