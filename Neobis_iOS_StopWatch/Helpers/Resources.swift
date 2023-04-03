//
//  Resources.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation
import UIKit

enum Resources {
    
    enum LayoutScreenSize {
        static let layoutWidth = 393.0
        static let layoutHeight = 852.0
        static var heightProportion = 0.0
        static var widthProportion = 0.0
    }
    
    enum ViewController {
        enum Colors {
            static let bgcolor = UIColor(RGB: [255,204,2])
        }
    }
    
    enum ButtonsStack {
        static let buttonsStackTop = adoptSize(tag: .height,
                                               size: 200.0)
        static let buttonsheight = adoptSize(tag: .height,
                                             size: 80.0)
    }
    
    enum TimeLabel {
        static let topAnchor = adoptSize(tag: .height,
                                         size: 50.0)
    }
    
    enum TimerImage {
        static let width = adoptSize(tag: .width,
                                     size: 100.0)
        static let height = adoptSize(tag: .width,
                                      size: 100.0)
    }
    
    enum SegmentedControl {
        
        enum Segments {
            static let timerSegment = "Timer"
            static let stopwatchSegment = "Stopwatch"
        }
        
        enum Sizes {
            static let width = adoptSize(tag: .width,
                                         size: 200.0)
            static let height = adoptSize(tag: .height,
                                          size: 30.0)
        }
    }
    
    enum Fonts {
        static let fontName = "HelveticaNeue-Bold"
        static let fontSize = 70.0
    }
    
    enum Paddings {
        static let horizontalPadding = adoptSize(tag: .width,
                                                 size: 20.0)
    }
    
    enum Buttons {
        enum Names {
            static let stopButton = "stop.circle.fill"
            static let pauseButton = "pause.circle"
            static let playButton = "play.circle.fill"
        }
    }
    
    private enum AdoptSize {
        case width
        case height
    }
    
    static private func adoptSize(tag: AdoptSize, size: Double) -> Double {
        switch tag {
        case .width:
            return size * LayoutScreenSize.widthProportion
        case .height:
            return size * LayoutScreenSize.heightProportion
        }
    }
}
