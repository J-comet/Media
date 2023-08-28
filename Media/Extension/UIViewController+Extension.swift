//
//  UIViewController+Extension.swift
//  Media
//
//  Created by 장혜성 on 2023/08/28.
//

import SwiftUI
import UIKit

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
