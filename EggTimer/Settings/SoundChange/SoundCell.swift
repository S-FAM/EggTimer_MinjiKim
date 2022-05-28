//
//  SoundCell.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//

import UIKit

final class SoundCell: UITableViewCell {
    static let identifier = "SoundCell"
    
    private let title = ["알림음 1", "알림음 2", "알림음 3", "알림음 4", "알림음 5", "알림음 6"]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!

    func update(_ row: Int) {
        titleLabel.text = title[row]
        
        let soundNum = SoundManager.getSound().rawValue
        if row == soundNum {
            selectImage.image = UIImage(systemName: "circle.fill")
            selectImage.tintColor = .label
        } else {
            selectImage.image = UIImage(systemName: "circle")
            selectImage.tintColor = .systemGray
        }
    }
}
