//
//  RecipeViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  레시피 화면 뷰 컨트롤러

import UIKit

final class RecipeViewController: UIViewController {
    private let viewModel = RecipeViewModel()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestRecipesList {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.tableview.reloadData()
            }
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
        return viewModel.recipes.count
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
        
        let recipe = viewModel.recipes[indexPath.row]
        cell.update(recipe)
        
        return cell
    }
    
    /// 셀이 보여지려고 할 때
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let currentRow = indexPath.row
        let currentPage = viewModel.currentPage
        let display = viewModel.display
        
        // 제일 뒤에서 3번째 행이면 다음 페이지 보여주기
        guard (currentRow % display) == (display - 3) && (currentRow / display) == (currentPage - 1) else { return }
        
        viewModel.requestRecipesList {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.tableview.reloadData()
            }
        }
    }
}
