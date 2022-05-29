//
//  SceneDelegate.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window?.tintColor = .label
    }

    /// Foreground 진입 시
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let start = UserDefaults.standard.object(
            forKey: .didEnterBackground
        ) as? Date else { return }
        
        let interval = Date().timeIntervalSince(start)
        
        NotificationCenter.default.post(
            name: .sceneWillEnterForeground,
            object: interval
        )
    }

    /// Background 진입 시
    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.set(Date(), forKey: .didEnterBackground)
        
        NotificationCenter.default.post(
            name: .sceneDidEnterBackground,
            object: nil
        )
    }
}

