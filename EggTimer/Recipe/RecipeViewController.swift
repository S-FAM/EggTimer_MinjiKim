//
//  RecipeViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  레시피 화면 뷰 컨트롤러

import UIKit

final class RecipeViewController: UIViewController {
    private let viewModel = RecipeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        RecipesSearchManager().request(start: 1, display: 10) { value in
            print(value)
        }
    }
}

// MARK: - UITableView
extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    /// 행 개수
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 10
    }
    
    /// 셀 구성
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecipeCell.identifier,
            for: indexPath
        ) as? RecipeCell else { return UITableViewCell() }
        
        cell.update()
        
        return cell
    }
}
