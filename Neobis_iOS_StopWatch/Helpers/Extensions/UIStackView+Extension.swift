//
//  UIStackView+Extension.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(subViews: [UIView]) {
        for view in subViews {
            addArrangedSubview(view)
        }
    }
}
