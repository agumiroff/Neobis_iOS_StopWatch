//
//  TimerService.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation

protocol TimerServiceProtocol: AnyObject {
    func startTimer(completion: @escaping (_ hours: Int,
                                           _ minutes: Int,
                                           _ seconds: Int) -> Void)
    func stopTimer(completion: @escaping (_ hours: Int,
                                          _ minutes: Int,
                                          _ seconds: Int) -> Void)
    func pauseTimer(completion: @escaping (_ hours: Int,
                                           _ minutes: Int,
                                           _ seconds: Int) -> Void)
    
    var seconds: Int { get set }
    var minutes: Int { get set }
    var hours: Int { get set }
}

class TimerService: TimerServiceProtocol {
    var totalSeconds = 0
    var seconds = 0
    var minutes = 0
    var hours = 0
    var timer: Timer?
    var isPlaying = false
    
    func startTimer(completion: @escaping (_ hours: Int,
                                           _ minutes: Int,
                                           _ seconds: Int) -> Void) {
        
        if isPlaying { return }
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        { [weak self] time in
            self?.totalSeconds += 1
            self?.calculateTime()
            completion(self!.hours, self!.minutes, self!.seconds)
        }
    }
    
    func stopTimer(completion: @escaping (_ hours: Int,
                                          _ minutes: Int,
                                          _ seconds: Int) -> Void) {
        if totalSeconds == 0 { return }
        isPlaying = false
        totalSeconds = 0
        calculateTime()
        timer?.invalidate()
        completion(self.hours, self.minutes, self.seconds)
    }
    
    func pauseTimer(completion: @escaping (_ hours: Int,
                                           _ minutes: Int,
                                           _ seconds: Int) -> Void) {
        if !isPlaying { return }
        isPlaying = false
        timer?.invalidate()
        completion(self.hours, self.minutes, self.seconds)
    }
    
    func calculateTime() {
        seconds = totalSeconds % 60
        minutes = (totalSeconds / 60) % 60
        hours = (totalSeconds / 3600) % 24
    }
    
}
