//
//  SceneDelegate.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window?.tintColor = .label
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let start = UserDefaults.standard.object(forKey: "sceneDidEnterBackground") as? Date else { return }
        let interval = Date().timeIntervalSince(start)
        NotificationCenter.default.post(
            name: NSNotification.Name("sceneWillEnterForeground"),
            object: interval
        )
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.set(Date(), forKey: "sceneDidEnterBackground")
        NotificationCenter.default.post(
            name: NSNotification.Name("sceneDidEnterBackground"),
            object: nil
        )
    }
}

