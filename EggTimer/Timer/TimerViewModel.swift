//
//  TimerViewModel.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머 화면 뷰 모델

import Foundation

enum TimerStatus {
    case start, pause, end
}

final class TimerViewModel {
    var duration = 300
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    
    var currentSec: Int = 300
    var min: Int = 0
    var sec: Int = 0
    
    func setTime(_ time: Int) {
        currentSec = time * 60
        min = currentSec / 60
        sec = currentSec % 60
    }
    
    func startTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            timer?.schedule(deadline: .now(), repeating: 1)
            timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }
                
                self.currentSec -= 1
                self.min = self.currentSec / 60
                self.sec = self.currentSec % 60
                
                NotificationCenter.default.post(name: NSNotification.Name("updateTimerUI"), object: [self.currentSec, self.min, self.sec])
                
                if self.currentSec <= 0 {
                    // 타이머 멈추기
                    // 알림음 내기
                }
            })
            timer?.resume()
        }
    }
}
