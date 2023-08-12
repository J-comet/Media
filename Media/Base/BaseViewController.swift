//
//  BaseViewController.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        designVC()
        configVC()
        configNavVC()
        configDefaultBackgroundColor()
    }
    
    private func configDefaultBackgroundColor() {
        self.view.backgroundColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = titleAttribute
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func designVC() {}
    
    func configVC() {}
    
    func configNavVC() {}
}
