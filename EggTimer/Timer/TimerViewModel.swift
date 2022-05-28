//
//  TimerViewModel.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머 화면 뷰 모델

import AudioToolbox
import Foundation

enum TimerStatus {
    case start, pause, end
}

// TODO: NotificationCenter를 Protocol로 바꿔보기!

final class TimerViewModel {
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var selectedTime: Int = 0
    
    var currentSec: Double = 0.0
    var min: Int = 0
    var sec: Int = 0
    
    func startTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            timer?.schedule(deadline: .now(), repeating: 0.01)
            timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else { return }

                self.currentSec -= 0.01

                NotificationCenter.default.post(
                    name: NSNotification.Name("updateTimerUI"),
                    object: (nil)
                )

                if self.currentSec <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                    NotificationCenter.default.post(
                        name: NSNotification.Name("endTimer"),
                        object: nil
                    )
                }
            })
            timer?.resume()
        }
    }
    
    func stopTimer() {
        NotificationCenter.default.post(
            name: NSNotification.Name("endTimer"),
            object: nil
        )
        if timerStatus == .pause {
            timer?.resume()
        }
        timerStatus = .end
        timer?.cancel()
        timer = nil
    }
}
