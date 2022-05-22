//
//  TimerViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머 화면 뷰 컨트롤러

import HGCircularSlider
import UIKit
import WaterDrops

final class TimerViewController: UIViewController {
    private let viewModel = TimerViewModel()

    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    private lazy var waterDropsView = WaterDropsView(
        frame: eggImageView.frame,
        direction: .up,
        dropNum: 10,
        color: .white,
        minDropSize: 10,
        maxDropSize: 20,
        minLength: 50,
        maxLength: 100,
        minDuration: 4,
        maxDuration: 8
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [cancelButton, startButton].forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
        
        circularSlider.minimumValue = 0.0
        circularSlider.maximumValue = 0.0
        circularSlider.endPointValue = 0.0

        waterDropsView.addAnimation()
        waterDropsView.isHidden = true
        view.addSubview(waterDropsView)
        
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
    }

    @IBAction func didTappedStartButton(_ sender: UIButton) {
        switch viewModel.timerStatus {
        case .end:
            viewModel.timerStatus = .start
            waterDropsView.isHidden = false
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
            startButton.setTitle("일시정지", for: .normal)
            viewModel.timer?.resume()
        }
    }
    
    @IBAction func didTappedCancelButton(_ sender: UIButton) {
        switch viewModel.timerStatus {
        case .start, .pause:
            cancelButton.isEnabled = false
            startButton.setTitle("시작", for: .normal)
            waterDropsView.isHidden = true
            
            eggImageView.image = UIImage(named: "egg_empty")
            timeLabel.text = "00:00"
            circularSlider.maximumValue = 0.0
            circularSlider.endPointValue = 0.0

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
        
        let time = Int(String(Array(image).suffix(from: 3)))
        viewModel.selectedTime = time!
        viewModel.setTime()
        
        circularSlider.maximumValue = CGFloat(time! * 60)
        circularSlider.endPointValue = CGFloat(time! * 60)
        
        eggImageView.image = UIImage(named: image)
        timeLabel.text = String(format: "%02d:%02d", viewModel.min, viewModel.sec)
    }
    
    /// 타이머가 실행됨에 따라 UI 업데이트하기
    @objc func updateTimerUI(_ notification: Notification) {
        guard let data = notification.object as? [Int] else { return }
        
        let currentSec = data[0]
        let min = data[1]
        let sec = data[2]

        circularSlider.endPointValue = CGFloat(currentSec)
        timeLabel.text = String(format: "%02d:%02d", min, sec)
    }
}
