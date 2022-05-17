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
    // TODO: 기본 타이머는 5분으로 초기화 해둘것!

    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [cancelButton, startButton].forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
        circularSlider.minimumValue = 0.0   // 최소값
        circularSlider.maximumValue = 1.0   // 최대값
        circularSlider.endPointValue = 0.9  // 현재값
        
//        let dayInSeconds = 24 * 60 * 60
//        circularSlider.maximumValue = CGFloat(dayInSeconds)
//
//        circularSlider.startPointValue = 1 * 60 * 60
//        circularSlider.endPointValue = 8 * 60 * 60
//        circularSlider.numberOfRounds = 2 // Two rotations for full 24h range
        
        // 보글보글 효과
        let waterDropsView = WaterDropsView(
            frame: timeLabel.frame,
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
        
        // add animation
        waterDropsView.addAnimation()
        view.addSubview(waterDropsView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setTimer(_:)),
            name: NSNotification.Name("selectedEgg"),
            object: nil
        )
    }
}

// MARK: - @objc Function
extension TimerViewController {
    /// 선택한 달걀 이미지와 타이머 시간 설정하기
    @objc func setTimer(_ notification: Notification) {
        guard let image = notification.object as? String else { return }
        let time = String(Array(image).suffix(from: 3))
        
        eggImageView.image = UIImage(named: image)
        timeLabel.text = time.count < 2 ? "0\(time):00" : "\(time):00"
    }
}
