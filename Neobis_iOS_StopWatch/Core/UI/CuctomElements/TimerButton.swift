//
//  TimerButton.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation
import UIKit

class TimerButton: UIButton {
    
    
    init(imageName: String, action: Selector) {
        super.init(frame: CGRect())
        let image = UIImage(systemName: imageName)
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.background.image = image?.withTintColor(.black,
                                                              renderingMode: .alwaysOriginal)
        configuration.background.imageContentMode = .scaleAspectFit
        self.configuration = configuration
        addTarget(superview, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
