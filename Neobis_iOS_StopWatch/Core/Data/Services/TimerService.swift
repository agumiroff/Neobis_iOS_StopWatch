//
//  TimerService.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation

protocol TimerServiceProtocol: AnyObject {
    func startTimer()
    func stopTimer()
    func pauseTimer()
    var timeString: String { get set }
}

class TimerService: TimerServiceProtocol {
    var timeString: String = "00:00:00"
    var totalSeconds = 0
    var timer: Timer?
    var isPlaying = false
    
    func startTimer() {
        
        if isPlaying { return }
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { [weak self] time in
            self?.totalSeconds += 1
            self?.updateData(totalSeconds: self!.totalSeconds)
        }
    }
    
    func stopTimer() {
        if totalSeconds == 0 { return }
        isPlaying = false
        totalSeconds = 0
        updateData(totalSeconds: self.totalSeconds)
        timer?.invalidate()
    }
    
    func pauseTimer() {
        if !isPlaying { return }
        isPlaying = false
        timer?.invalidate()
    }
    
    func updateData(totalSeconds: Int) {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = (totalSeconds / 3600) % 24
        
        timeString = String(format: "%02d:%02d:%02d",
                                hours, minutes, seconds)
        NotificationCenter.default.post(name: Notification.Name("totalSeconds"),
                                        object: timeString)
    }
    
}
