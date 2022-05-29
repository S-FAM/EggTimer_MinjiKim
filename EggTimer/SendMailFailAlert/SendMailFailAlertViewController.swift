//
//  SendMailFailAlertViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//

import Foundation
import UIKit

final class SendMailFailAlertViewController: UIViewController {
    static let identifier = "SendMailFailAlertViewController"
    
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 12.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAppearance()
    }
    
    func setupAppearance() {
        DarkModeManager.applyAppearance(
            mode: DarkModeManager.getAppearance(),
            viewController: self
        )
    }
    
    @IBAction func didTappedDismissButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func didTappedMoveButton(_ sender: UIButton) {
        let store = "https://apps.apple.com/kr/app/mail/id1108187098"
        if let url = URL(string: store), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
