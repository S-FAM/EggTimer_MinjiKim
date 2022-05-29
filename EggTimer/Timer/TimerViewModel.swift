//
//  TimerViewModel.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머 화면 뷰 모델

import AVFoundation
import Foundation
import UserNotifications

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
    
    var player: AVAudioPlayer!
    
    func startTimer() {
        if timer == nil {
            let content = UNMutableNotificationContent()
            content.title = "이제 꺼내주세요~!"
            content.body = "원하는 익힘의 삶은 달걀이 완성되었어요! 꺼내서 바로 찬물에 넣어주세요~"
            content.sound = SoundManager.getSound().notificationSound
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.currentSec, repeats: false)
            
            let request = UNNotificationRequest(identifier: "done", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
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
