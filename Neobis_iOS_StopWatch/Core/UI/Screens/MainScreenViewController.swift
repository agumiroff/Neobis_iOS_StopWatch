//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import UIKit

class MainScreenViewController: UIViewController, UIScrollViewDelegate {
      
    //MARK: Properties
    var timerService: TimerServiceProtocol!
    var segmentedControl: UISegmentedControl!
    var timer: Timer?
    var totalSeconds = 1
    let stopButton = TimerButton(imageName: Resources.Buttons.Names.stopButton,
                                 action: #selector(stopTimer))
    let pauseButton = TimerButton(imageName: Resources.Buttons.Names.pauseButton,
                                  action: #selector(pauseTimer))
    let playButton = TimerButton(imageName: Resources.Buttons.Names.playButton,
                                 action: #selector(startTimer(sender:)))
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let timerImage: UIImageView = {
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
        return label
    }()

    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.ViewController.Colors.bgcolor
        updateUI()
        setupViews()
        subscribeOnTimer()
    }
    
    
}


//MARK: Views setup
extension MainScreenViewController {
    
    private func setupViews() {
        setupScrollView()
        timerImageSetup()
        segmentedControlSetup()
        timeLabelSetup()
        buttonsStackSetup()
    }
    
    //MARK: ScrollView setup
    private func setupScrollView() {
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
        ])
    }
    
    //MARK: TimerImage setup
    func timerImageSetup() {
        contentView.addSubview(timerImage)
        
        timerImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                           constant: 20),
            timerImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timerImage.widthAnchor.constraint(equalToConstant: Resources.TimerImage.width),
            timerImage.heightAnchor.constraint(equalToConstant: Resources.TimerImage.height),
        ])
    }
    
    //MARK: SegmentedControl setup
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
        
        contentView.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: timerImage.bottomAnchor,
                                                  constant: Resources.Paddings.horizontalPadding),
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: Resources.SegmentedControl.Sizes.height),
            segmentedControl.widthAnchor.constraint(equalToConstant: Resources.SegmentedControl.Sizes.width),
        ])
    }
    
    //MARK: timeLabel setup
    func timeLabelSetup() {
        contentView.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                           constant: Resources.TimeLabel.topAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func circleSliderSetup() {
        
    }
    
    //MARK: Buttons setup
    func buttonsStackSetup() {
        
        buttonsStack.addArrangedSubviews(subViews: [
            stopButton, pauseButton, playButton,
        ])
        
        contentView.addSubview(buttonsStack)
        
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: Resources.Paddings.horizontalPadding),
            buttonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -Resources.Paddings.horizontalPadding),
            buttonsStack.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,
                                              constant: Resources.ButtonsStack.buttonsStackTop),
            buttonsStack.heightAnchor.constraint(equalToConstant: Resources.ButtonsStack.buttonsheight),
        ])
    }
    
}

//MARK: Methods
extension MainScreenViewController {
    
    private func subscribeOnTimer() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("totalSeconds"), object: nil)
    }
    
    @objc func updateUI() {
        self.timeLabel.text = timerService.timeString
    }
    
    @objc func startTimer(sender: UIButton) {
        timerService.startTimer()
    }
    
    @objc func stopTimer() {
        timerService.stopTimer()
    }
    
    @objc func pauseTimer() {
        timerService.pauseTimer()
    }
    
    @objc func segmentDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            timerImage.image = UIImage(systemName: "timer")
        case 1:
            timerImage.image = UIImage(systemName: "stopwatch")
        default:
            break
        }
    }
}
