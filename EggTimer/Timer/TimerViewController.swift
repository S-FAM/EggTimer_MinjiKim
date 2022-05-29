//
//  TimerViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머 화면 뷰 컨트롤러

import HGCircularSlider
import PanModal
import UIKit
import UserNotifications
import WaterDrops

final class TimerViewController: UIViewController {
    private let viewModel = TimerViewModel()

    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var eggButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    /// Length: 범위, Duration: 속도
    private lazy var waterDropsView = WaterDropsView(
        frame: CGRect(
            x: eggButton.frame.minX,
            y: eggButton.frame.maxY,
            width: eggButton.bounds.width,
            height: eggButton.bounds.height
        ),
        direction: .up,
        dropNum: 10,
        color: .white,
        minDropSize: 10,
        maxDropSize: 20,
        minLength: 50,
        maxLength: eggButton.bounds.height,
        minDuration: 1,
        maxDuration: 5
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [cancelButton, startButton].forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
        
        circularSlider.minimumValue = 0.0
        circularSlider.maximumValue = 0.0
        circularSlider.endPointValue = 0.0

        waterDropsView.isHidden = true
        view.addSubview(waterDropsView)
        
        setupNoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        waterDropsView.addAnimation()
        setupAppearance()
    }
    
    func setupAppearance() {
        DarkModeManager.applyAppearance(
            mode: DarkModeManager.getAppearance(),
            viewController: self
        )
    }
    
    func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setTimer(_:)),
            name: NSNotification.Name("selectedEgg"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTimerUI(_:)),
            name: NSNotification.Name("updateTimerUI"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(endTimer(_:)),
            name: NSNotification.Name("endTimer"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground(_:)),
            name: NSNotification.Name("sceneWillEnterForeground"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground(_:)),
            name: NSNotification.Name("sceneDidEnterBackground"),
            object: nil
        )
    }
    
    @IBAction func didTappedEggButton(_ sender: UIButton) {
        let eggViewController = storyboard?.instantiateViewController(withIdentifier: EggsViewController.identifier) as! EggsViewController
        presentPanModal(eggViewController)
    }
    
    @IBAction func didTappedStartButton(_ sender: UIButton) {
        switch viewModel.timerStatus {
        case .end:
            viewModel.timerStatus = .start
            waterDropsView.isHidden = false
            eggButton.isEnabled = false
            cancelButton.isEnabled = true
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            viewModel.startTimer()
        case .start:
            viewModel.timerStatus = .pause
            waterDropsView.isHidden = true
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            viewModel.timer?.suspend()
        case .pause:
            viewModel.timerStatus = .start
            waterDropsView.isHidden = false
            eggButton.isEnabled = false
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            viewModel.timer?.resume()
        }
    }
    
    @IBAction func didTappedCancelButton(_ sender: UIButton) {
        switch viewModel.timerStatus {
        case .start, .pause:
            viewModel.stopTimer()
        default:
            break
        }
    }
    
    func updateTimeLabel(_ currentSec: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let time = Date(timeIntervalSince1970: TimeInterval(currentSec))
        timeLabel.text = formatter.string(from: time)
    }
}

// MARK: - @objc Function
extension TimerViewController {
    /// 선택한 달걀 이미지와 타이머 시간 설정하기
    @objc func setTimer(_ notification: Notification) {
        guard let image = notification.object as? String else { return }
        
        let time = Double(image.components(separatedBy: "egg").last!)
        if time == Double(5) {
            viewModel.currentSec = 10.0
        } else {
            viewModel.currentSec = time! * 60.0
        }
        
        circularSlider.maximumValue = CGFloat(viewModel.currentSec)
        circularSlider.endPointValue = CGFloat(viewModel.currentSec)
        
        eggButton.setImage(UIImage(named: image), for: .normal)
        updateTimeLabel(viewModel.currentSec)
        startButton.isEnabled = true
    }
    
    /// 타이머가 실행됨에 따라 UI 업데이트하기
    @objc func updateTimerUI(_ notification: Notification) {
        circularSlider.endPointValue = CGFloat(viewModel.currentSec)
        updateTimeLabel(viewModel.currentSec)
    }
    
    @objc func endTimer(_ notification: Notification) {
        circularSlider.maximumValue = 0.0
        circularSlider.endPointValue = 0.0
        
        eggButton.isEnabled = true
        eggButton.setImage(UIImage(named: "egg_empty"), for: .normal)
        
        waterDropsView.isHidden = true
        cancelButton.isEnabled = false
        startButton.isEnabled = false
        eggButton.isEnabled = true
        
        timeLabel.text = "00:00"
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        viewModel.removePushNotification()
    }
    
    @objc func willEnterForeground(_ notification: Notification) {
        waterDropsView.addAnimation()

        guard let interval = notification.object as? Double else { return }
        
        viewModel.currentSec -= interval
        viewModel.removePushNotification()
    }
    
    @objc func didEnterBackground(_ notification: Notification) {
        viewModel.makePushNotification()
    }
}
