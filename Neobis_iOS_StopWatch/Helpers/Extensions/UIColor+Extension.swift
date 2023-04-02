//
//  UIColor+Extension.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(RGB: [Int]) {
        self.init(red: CGFloat(Double(RGB[0])/255),
                  green: CGFloat(Double(RGB[1])/255),
                  blue: CGFloat(Double(RGB[2])/255),
                  alpha: 1)
    }
}
