//
//  TimerViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머 화면 뷰 컨트롤러

import HGCircularSlider
import PanModal
import UIKit
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
        frame: timeLabel.frame,
        direction: .up,
        dropNum: 10,
        color: .white,
        minDropSize: 10,
        maxDropSize: 20,
        minLength: 50,
        maxLength: eggButton.bounds.height,
        minDuration: 4,
        maxDuration: 8
    )
    // TODO: 시작할 때 흰달걀 이미지 넣고 상태별로 서서히 변하기
    
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
        // 화면이 보여질 때마다 애니메이션 실행!
        // TODO: 다만, 백그라운드 -> 포그라운드로 오면 waterDrop 효과가 보이지 않음..!
        waterDropsView.addAnimation()
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
    }
    
    @IBAction func didTappedEggButton(_ sender: UIButton) {
        let eggViewController = storyboard?.instantiateViewController(withIdentifier: EggsViewController.identifier) as! EggsViewController
        presentPanModal(eggViewController)
    }
    
    @IBAction func didTappedStartButton(_ sender: UIButton) {
        switch viewModel.timerStatus {
        case .end:
            // TODO: 함수로 묶어버리기
            viewModel.timerStatus = .start
            waterDropsView.isHidden = false
            eggButton.isEnabled = false
            cancelButton.isEnabled = true
            startButton.setTitle("일시정지", for: .normal)
            viewModel.startTimer()
        case .start:
            viewModel.timerStatus = .pause
            waterDropsView.isHidden = true
            startButton.setTitle("시작", for: .normal)
            viewModel.timer?.suspend()
        case .pause:
            viewModel.timerStatus = .start
            waterDropsView.isHidden = false
            eggButton.isEnabled = false
            startButton.setTitle("일시정지", for: .normal)
            viewModel.timer?.resume()
        }
    }
    
    @IBAction func didTappedCancelButton(_ sender: UIButton) {
        switch viewModel.timerStatus {
        case .start, .pause:
            eggButton.isEnabled = true
            eggButton.setImage(UIImage(named: "egg_empty"), for: .normal)
            timeLabel.text = "00:00"
            
            circularSlider.maximumValue = 0.0
            circularSlider.endPointValue = 0.0
            
            waterDropsView.isHidden = true
            cancelButton.isEnabled = false
            startButton.isEnabled = false
            startButton.setTitle("시작", for: .normal)
            
            viewModel.stopTimer()
        default:
            break
        }
    }
}

// MARK: - @objc Function
extension TimerViewController {
    /// 선택한 달걀 이미지와 타이머 시간 설정하기
    @objc func setTimer(_ notification: Notification) {
        guard let image = notification.object as? String else { return }
        
        let time = Int(image.components(separatedBy: "egg").last!)
        viewModel.selectedTime = time!
        viewModel.setTime()
        
        circularSlider.maximumValue = CGFloat(time! * 60)
        circularSlider.endPointValue = CGFloat(time! * 60)
        
        eggButton.setImage(UIImage(named: image), for: .normal)
        timeLabel.text = String(format: "%02d:%02d", viewModel.min, viewModel.sec)
        startButton.isEnabled = true
    }
    
    /// 타이머가 실행됨에 따라 UI 업데이트하기
    @objc func updateTimerUI(_ notification: Notification) {
        guard let data = notification.object
                as? (current: Int, minute: Int, second: Int) else { return }
        // 튜플 네이밍으로 더 알아보기 쉽게.
        
        let currentSec = data.current
        let min = data.minute
        let sec = data.second

        circularSlider.endPointValue = CGFloat(currentSec)
        timeLabel.text = String(format: "%02d:%02d", min, sec)
    }
    
    @objc func endTimer(_ notification: Notification) {
        eggButton.isEnabled = true
        eggButton.setImage(UIImage(named: "egg_empty"), for: .normal)
        waterDropsView.isHidden = true
    }
}
