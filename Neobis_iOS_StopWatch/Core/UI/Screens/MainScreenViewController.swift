//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    
    //MARK: Properties
    
    var segmentedControl: UISegmentedControl!
    var timer: Timer?
    var totalSeconds = 0
    let stopButton = TimerButton(imageName: Resources.Buttons.Names.stopButton)
    let pauseButton = TimerButton(imageName: Resources.Buttons.Names.pauseButton)
    let playButton = TimerButton(imageName: Resources.Buttons.Names.playButton)
    
    let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "timer")
        logo.tintColor = .black
        return logo
    }()
    
    var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .fill
        stack.backgroundColor = .clear
        stack.distribution = .fillEqually
        return stack
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Resources.Fonts.fontName,
                            size: Resources.Fonts.fontSize)
        label.text = "00:00:00"
        return label
    }()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.bgcolor
        logoImageSetup()
        segmentedControlSetup()
        timeLabelSetup()
        buttonsStackSetup()
    }


}

//MARK: Views setup
extension MainScreenViewController {
  
    func logoImageSetup() {
        view.addSubview(logoImage)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 20),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func segmentedControlSetup() {
        let items = [
            Resources.SegmentedControl.Segments.timerSegment,
            Resources.SegmentedControl.Segments.stopwatchSegment,
        ]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self,
                                   action: #selector(segmentDidChange(_:)),
                                   for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: logoImage.bottomAnchor,
                                                  constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func timeLabelSetup() {
        view.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                           constant: 50),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func buttonsStackSetup() {
        
        buttonsStack.addArrangedSubviews(subViews: [
            stopButton, pauseButton, playButton,
        ])
        
        view.addSubview(buttonsStack)
        
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Resources.Paddings.horizontalPadding),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -Resources.Paddings.horizontalPadding),
            buttonsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                  constant: -200),
            buttonsStack.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
}

//MARK: Methods setup
extension MainScreenViewController {
    
    func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(startTimer(sender:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func startTimer(sender: Timer) {
        totalSeconds += 600
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = (totalSeconds / 3600) % 24
        self.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

//MARK: Segmented control
extension MainScreenViewController {
    

    
    @objc func segmentDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: break
            
        case 1:
            print("stopwatch segment")
        default:
            break
        }
    }
}
