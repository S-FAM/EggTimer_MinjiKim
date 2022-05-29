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
}

// MARK: - UICollectionView
extension BasicRecipeViewController: UICollectionViewDataSource {
    /// 셀 개수
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 5
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
