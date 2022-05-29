//
//  SettingsViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//  설정 화면 ViewController

import Foundation
import MessageUI
import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    /// 다크 모드 화면 push
    func pushToDarkModeViewController() {
        let darkModeViewController = storyboard?.instantiateViewController(
            withIdentifier: DarkModeViewController.identifier
        ) as! DarkModeViewController
        navigationController?.pushViewController(darkModeViewController, animated: true)
    }
    
    /// 알림음 변경 화면 push
    func pushToSoundViewController() {
        let soundViewController = storyboard?.instantiateViewController(
            withIdentifier: SoundViewController.identifier
        ) as! SoundViewController
        navigationController?.pushViewController(soundViewController, animated: true)
    }
    
    /// 의견 보내기 화면 띄우기
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            let currentMode = DarkModeManager.getAppearance().rawValue
            composeViewController.overrideUserInterfaceStyle = currentMode == 0 ? .light : .dark
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients(["kimminji080122@gmail.com"])
            composeViewController.setSubject("<EggTimer> 문의 및 의견")
            composeViewController.setMessageBody(viewModel.commentsBodyString(), isHTML: false)
            composeViewController.modalPresentationStyle = .fullScreen
            present(composeViewController, animated: true)
        } else {
            let sendMailFailAlertViewController = storyboard?.instantiateViewController(
                withIdentifier: SendMailFailAlertViewController.identifier
            ) as! SendMailFailAlertViewController
            sendMailFailAlertViewController.modalPresentationStyle = .overCurrentContext
            present(sendMailFailAlertViewController, animated: false)
        }
    }
    
    /// 이용 방법 화면 보여주기
    func openHowtoUse() {
        let link = "https://midi-dill-147.notion.site/EggTimer-22bab711a2fa4743a0f689da9e963ec2"
        guard let url = URL(string: link),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - UITableView
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    /// 셀 개수
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 5
    }
    
    /// 셀 구성
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.identifier
        ) as? SettingsCell else { return UITableViewCell() }
        
        cell.update(indexPath.row)
        return cell
    }
    
    /// 셀 클릭
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        switch indexPath.row {
        case 0: pushToDarkModeViewController()
        case 1: pushToSoundViewController()
        case 2: sendMail()
        case 3: openHowtoUse()
        default: break
        }
    }
}

// MARK: - MailComposeViewController Delegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    /// (의견 보내기) 메일 보낸 후
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        dismiss(animated: true)
    }
}
