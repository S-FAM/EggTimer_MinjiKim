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

final class TimerViewModel {
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var selectedTime: Int = 0
    
    var currentSec: Double = 0.0
    var min: Int = 0
    var sec: Int = 0
    
    var player: AVAudioPlayer!
    
    /// 타이머 시작
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
                    self.playSound()
                }
            })
            timer?.resume()
        }
    }
    
    /// 타이머 종료
    func stopTimer() {
        postEndTimerNoti()
        if timerStatus == .pause {
            timer?.resume()
        }
        timerStatus = .end
        timer?.cancel()
        timer = nil
    }
    
    /// done 푸시 알림 노티 만들기
    func makePushNotification() {
        guard currentSec > 0 else { return }
        let content = UNMutableNotificationContent()
        content.title = "이제 꺼내주세요~!"
        content.body = "원하는 익힘의 삶은 달걀이 완성되었어요! 꺼내서 바로 찬물에 넣어주세요~"
        content.sound = SoundManager.getSound().notificationSound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: currentSec, repeats: false)
        
        let request = UNNotificationRequest(identifier: "done", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// done 푸시 알림 노티 삭제하기
    func removePushNotification() {
        guard currentSec > 0 else { return }
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["done"])
    }
    
    /// endTimer 노티 발송
    func postEndTimerNoti() {
        NotificationCenter.default.post(
            name: NSNotification.Name("endTimer"),
            object: nil
        )
    }
    
    /// 알림음 실행
    func playSound() {
        let soundName = String(SoundManager.getSound().rawValue + 1)
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
