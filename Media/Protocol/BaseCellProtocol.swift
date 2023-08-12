//
//  BaseCellProtocol.swift
//  Media
//
//  Created by 장혜성 on 2023/08/12.
//

import UIKit

protocol BaseCellProtocol {
    associatedtype T
    func designCell()
    func configureCell(row: T)
}
