//
//  Resources.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation
import UIKit

enum Resources {
    
    enum Colors {
        static var bgcolor = UIColor(RGB: [255,204,2])
    }
    
    enum SegmentedControl {
        
        enum Segments {
            static var timerSegment = "Timer"
            static var stopwatchSegment = "Stopwatch"
        }
        
        enum Sizes {
            static var width = 200.0
            static var height = 80.0
        }
    }
    
    enum Fonts {
        static var fontName = "HelveticaNeue-Bold"
        static var fontSize = 80.0
    }
    
    enum Paddings {
        static var horizontalPadding = 20.0
    }
    
    enum Buttons {
        enum Names {
            static var stopButton = "stop.circle.fill"
            static var pauseButton = "pause.circle.fill"
            static var playButton = "play.circle.fill"
        }
        
        enum Tags {
            case play
            case stop
            case pause
        }
    }
}
