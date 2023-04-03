//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import UIKit

class MainScreenViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    var isTimer = true
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
    private let seconds = Array(1...59)
    private let hours = Array(1...23)
    
    private let timePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private let timerImage: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(systemName: "timer")
        logo.tintColor = .black
        return logo
    }()
    
    private var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .fill
        stack.backgroundColor = .clear
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var timeLabel: UILabel = {
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
        setupPickerView()
        subscribeOnTimer()
    }
    
    
}

//MARK: PickerView methods
extension MainScreenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        default:
            return seconds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(hours.reversed()[row])
        default:
            return String(seconds.reversed()[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: //hours
            timerService.setStopwatchTimer(hours: hours.reversed()[row],
                                           minutes: nil,
                                           seconds: nil)
        case 1: //minutes
            timerService.setStopwatchTimer(hours: nil,
                                           minutes: seconds.reversed()[row],
                                           seconds: nil)
        default: //seconds
            timerService.setStopwatchTimer(hours: nil,
                                           minutes: nil,
                                           seconds: seconds.reversed()[row])
        }
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    //MARK: PickerView setup
    func setupPickerView() {
        
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.isHidden = true
        
        contentView.addSubview(timePicker)
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,
                                            constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant:  Resources.Paddings.horizontalPadding),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant:  -Resources.Paddings.horizontalPadding),
            timePicker.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor,
                                               constant:  -20)
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
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
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
        timerService.startTimer(isTimer: isTimer)
        timePicker.isUserInteractionEnabled = false
    }
    
    @objc func stopTimer() {
        timerService.stopTimer()
        timePicker.isUserInteractionEnabled = true
    }
    
    @objc func pauseTimer() {
        timerService.pauseTimer()
    }
    
    @objc func segmentDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            isTimer = true
            stopTimer()
            timerImage.image = UIImage(systemName: "timer")
            timePicker.isHidden = true
        case 1:
            isTimer = false
            stopTimer()
            timerImage.image = UIImage(systemName: "stopwatch")
            timePicker.isHidden = false
        default:
            break
        }
    }
}
