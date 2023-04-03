//
//  TimerService.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation

//MARK: Protocol
protocol TimerServiceProtocol: AnyObject {
    func startTimer(isTimer: Bool)
    func stopTimer()
    func pauseTimer()
    func setStopwatchTimer(hours: Int?, minutes: Int?, seconds: Int?)
    var timeString: String { get set }
}

class TimerService: TimerServiceProtocol {
    
    //MARK: Properties
    private var totalSeconds = 0
    private var seconds = 0
    private var minutes = 0
    private var hours = 0
    private var timer: Timer?
    private var isPlaying = false
    var timeString: String = "00:00:00"
    
    
    //MARK: Methods
    func setStopwatchTimer(hours: Int?, minutes: Int?, seconds: Int?) {
        self.hours = hours ?? self.hours
        self.minutes = minutes ?? self.minutes
        self.seconds = seconds ?? self.seconds
        notifyObservers()
    }
    
    func startTimer(isTimer: Bool) {
        calculateTotalSeconds()
        if isPlaying { return }
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { [weak self] time in
            if self?.totalSeconds == 0 && !isTimer {
                time.invalidate()
                return
            }
            self?.totalSeconds += isTimer ? 1 : -1
            self?.convertSecondsInTime()
            self?.notifyObservers()
        }
    }
    
    func stopTimer() {
        calculateTotalSeconds()
        if totalSeconds == 0 { return }
        isPlaying = false
        totalSeconds = 0
        convertSecondsInTime()
        notifyObservers()
        timer?.invalidate()
    }
    
    func pauseTimer() {
        if !isPlaying { return }
        isPlaying = false
        timer?.invalidate()
    }
    
    private func calculateTotalSeconds() {
        self.totalSeconds += self.seconds
        self.totalSeconds += self.minutes * 60
        self.totalSeconds += self.hours * 3600
        convertSecondsInTime()
    }
    
    private func convertSecondsInTime() {
        self.seconds = totalSeconds % 60
        self.minutes = (totalSeconds / 60) % 60
        self.hours = (totalSeconds / 3600) % 24
    }
    
    private func notifyObservers() {
        timeString = String(format: "%02d:%02d:%02d",
                                hours, minutes, seconds)
        NotificationCenter.default.post(name: Notification.Name("totalSeconds"),
                                        object: timeString)
    }
    
}
