//
//  SettingsViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//

import Foundation
import MessageUI
import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
//            composeViewController.overrideUserInterfaceStyle = DarkModeManager.getAppearance().rawValue == 0 ? .light : .dark
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients(["kimminji080122@gmail.com"])   // TODO: 앱 이름 넣기
            composeViewController.setSubject("<EggTimer> 문의 및 의견")
            composeViewController.setMessageBody(viewModel.commentsBodyString(), isHTML: false)
            composeViewController.modalPresentationStyle = .fullScreen
            present(composeViewController, animated: true)
        } else {
            let sendMailFailAlertViewController = SendMailFailAlertViewController()
            sendMailFailAlertViewController.modalPresentationStyle = .overCurrentContext
            present(sendMailFailAlertViewController, animated: false)
        }
    }
}

// MARK: - UITableView
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.identifier
        ) as? SettingsCell else { return UITableViewCell() }
        
        cell.update(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: break
        case 1: break
        case 2: sendMail()
        case 3: break
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
