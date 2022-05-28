//
//  SettingsCell.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//  설정 화면 테이블 뷰 셀

import UIKit

final class SettingsCell: UITableViewCell {
    static let identifier = "SettingsCell"

    /// Cell Icon Image
    private var image = ["moon", "speaker.wave.2", "paperplane", "questionmark.circle", "info.circle"]

    /// Cell Title Text
    private var title = ["다크 모드", "알림음 변경", "의견 보내기", "이용 방법", "버전 정보"]

    /// Cell Detail Text
    private lazy var detail = ["", "", "", "", "v\(getCurrentVersion())"]

    /// 셀 UI 업데이트
    func update(_ row: Int) {
        imageView?.image = UIImage(systemName: image[row])
        textLabel?.text = title[row]
        detailTextLabel?.text = detail[row]
    }
}

private extension SettingsCell {
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}
