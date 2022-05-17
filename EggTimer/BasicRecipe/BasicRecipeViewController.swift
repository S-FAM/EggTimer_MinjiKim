//
//  BasicRecipeViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  기본 레시피 화면(달걀 예쁘게 삶는 방법) 뷰 컨트롤러

import UIKit

final class BasicRecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollectionView
extension BasicRecipeViewController: UICollectionViewDataSource {
    /// 셀 개수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 4
    }
    
    /// 셀 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BasicRecipeCell.identifier,
            for: indexPath
        ) as? BasicRecipeCell else { return UICollectionViewCell() }

        cell.update(indexPath.row)

        return cell
    }
}
