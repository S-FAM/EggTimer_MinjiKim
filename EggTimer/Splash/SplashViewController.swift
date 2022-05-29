//
//  SplashViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/29.
//  스플래쉬 화면 ViewController

import UIKit
import WaterDrops

final class SplashViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private lazy var waterDropsView = WaterDropsView(
        frame: view.frame,
        direction: .up,
        dropNum: 15,
        color: .white,
        minDropSize: 10,
        maxDropSize: 30,
        minLength: 50,
        maxLength: view.bounds.height,
        minDuration: 1,
        maxDuration: 3
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waterDropsView.addAnimation()
        self.view.addSubview(waterDropsView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "presentTabBarController", sender: self)
        }
    }
    
    func showAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }
    }
}
