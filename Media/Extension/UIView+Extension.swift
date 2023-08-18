//
//  UIView+Extension.swift
//  Media
//
//  Created by 장혜성 on 2023/08/18.
//

import UIKit

extension UIView{
    func setLinearGradient(start: UIColor, end: UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [start.withAlphaComponent(0.8).cgColor, end.withAlphaComponent(0).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
