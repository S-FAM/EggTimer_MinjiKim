//
//  SoundManager.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//  알림음 관리자

import Foundation
import UserNotifications

enum Sound: Int {
    case sound1, sound2, sound3, sound4, sound5, sound6
    
    var notificationSound: UNNotificationSound {
        switch self {
        case .sound1:
            return UNNotificationSound(named: UNNotificationSoundName("1.wav"))
        case .sound2:
            return UNNotificationSound(named: UNNotificationSoundName("2.wav"))
        case .sound3:
            return UNNotificationSound(named: UNNotificationSoundName("3.wav"))
        case .sound4:
            return UNNotificationSound(named: UNNotificationSoundName("4.wav"))
        case .sound5:
            return UNNotificationSound(named: UNNotificationSoundName("5.wav"))
        case .sound6:
            return UNNotificationSound(named: UNNotificationSoundName("6.wav"))
        }
    }
}

final class SoundManager {
    /// Sound 가져오기 (Default: sound1)
    static func getSound() -> Sound {
        guard let sound = (
            UserDefaults.standard.value(forKey: "Sound") as AnyObject
        ).integerValue else { return Sound(rawValue: 0)! }

        return Sound(rawValue: sound)!
    }

    /// Sound 저장하기
    static func setSound(sound: Sound) {
        UserDefaults.standard.setValue(sound.rawValue, forKey: "Sound")
        UserDefaults.standard.synchronize()
    }
}
