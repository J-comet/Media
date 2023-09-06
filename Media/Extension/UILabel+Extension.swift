//
//  UILabel+Extension.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

extension UILabel {
  func countLines() -> Int {
    guard let text = self.text as NSString? else {
      return 0
    }
    // Call self.layoutIfNeeded() if your view uses auto layout
    let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
    return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
  }
}
