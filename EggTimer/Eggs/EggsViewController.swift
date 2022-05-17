//
//  EggsViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  타이머로 선택할 달걀을 보여줄 화면 뷰 컨트롤러

import UIKit

final class EggsViewController: UIViewController {
    private let images: [String] = ["egg5", "egg6", "egg7", "egg8", "egg9", "egg10"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollectionView
extension EggsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    /// 셀 개수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 6
    }
    
    /// 셀 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EggsCell.identifier,
            for: indexPath
        ) as? EggsCell else { return UICollectionViewCell() }
        
        cell.update(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("selectedEgg"), object: images[indexPath.row])
    }
}
