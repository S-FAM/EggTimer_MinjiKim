//
//  DarkModeCell.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//  Appearance 변경 테이블 뷰 셀

import UIKit

final class DarkModeCell: UITableViewCell {
    static let identifier = "DarkModeCell"

    private let title = ["라이트 모드", "다크 모드"]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!

    func update(_ row: Int, _ mode: Mode) {
        titleLabel.text = title[row]

        if (mode == .light && row == 0) || (mode == .dark && row == 1) {
            selectImage.image = UIImage(systemName: "circle.fill")
            selectImage.tintColor = .label
        } else {
            selectImage.image = UIImage(systemName: "circle")
            selectImage.tintColor = .systemGray
        }
    }
}
