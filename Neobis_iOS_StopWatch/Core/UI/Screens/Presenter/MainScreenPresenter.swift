//
//  MainScreenPresenter.swift
//  Neobis_iOS_StopWatch
//
//  Created by G G on 02.04.2023.
//

import Foundation
import Combine

protocol MainScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    func startTimer()
    func stopTimer()
    func pauseTimer()
    func showStopWatch()
    func showTimer()
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    
    weak var view: MainScreenProtocol!
    var timerService: TimerServiceProtocol!
    var totalSeconds = 0
    @Published var timeString: String = "00:00:00"
    var cancellable = Set<AnyCancellable>()
        
    func viewDidLoad() {
        $timeString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.view.updateUI(newValue: value)
                print(value)
            }
            .store(in: &cancellable)
        NotificationCenter.default.addObserver(self, selector: #selector(countSeconds), name: NSNotification.Name("totalSeconds"), object: nil)
    }
    
    @objc func countSeconds() {
        totalSeconds += 1
        print(totalSeconds)
    }
    
    func startTimer() {
        timerService.startTimer {[weak self] hours, minutes, seconds in
            self?.timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func stopTimer() {
        timerService.stopTimer { hours, minutes, seconds in
            self.timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func pauseTimer() {
        timerService.pauseTimer { hours, minutes, seconds in
            self.timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func showStopWatch() {
        
    }
    
    func showTimer() {
        
    }
}
