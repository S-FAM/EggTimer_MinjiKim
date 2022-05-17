//
//  EggsCell.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머로 설정할 달걀 셀

import UIKit

final class EggsCell: UICollectionViewCell {
    static let identifier = "EggsCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private let images: [String] = ["egg5", "egg6", "egg7", "egg8", "egg9", "egg10"]
    private let titles: [String] = ["5분", "6분", "7분", "8분", "9분", "10분"]
    private let contents: [String] = [
        "노른자가 흐르는 반숙", "노른자가 흐를 듯한 반숙", "노른자가 촉촉한 반숙",
        "노른자가 퍽퍽하지 않은 완숙", "노른자가 촉촉한 완숙", "노른자가 퍽퍽한 완숙"
    ]
    
    func update(_ row: Int) {
        imageView.image = UIImage(named: images[row])
        titleLabel.text = titles[row]
        contentLabel.text = contents[row]
    }
}
