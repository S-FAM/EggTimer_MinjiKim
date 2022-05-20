//
//  RecipeViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  레시피 화면 뷰 컨트롤러

import UIKit

final class RecipeViewController: UIViewController {
    private let viewModel = RecipeViewModel()
    
    /// RecipeDetailViewController를 push하는 Segue의 identifier
    private let segueIdentifier = "pushToRecipeDetail"

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkCheck.shared.startMonitoring { [weak self] isConnect in
            guard let self = self else { return }

            if isConnect {
                self.viewModel.requestRecipesList {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.tableview.reloadData()
                    }
                }
            } else {
                // 연결안됨 -> 네트워크 연결이 안되었음을 알린다.
            }
        }
    }
    
    // 세그웨이 실행되면 선택된 레시피를 상세화면으로 넘겨주면서 push 하기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let vc = segue.destination as? RecipeDetailViewController
            
            if let row = sender as? Int {
                let recipe = viewModel.recipeInfo(at: row)
                vc?.recipe = recipe
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
        return viewModel.numOfRecipes
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
        
        let recipe = viewModel.recipeInfo(at: indexPath.row)
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
    
    /// 셀이 클릭되었을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 세그웨이 실행! -> 레시피 상세 화면 push 하기
        performSegue(withIdentifier: segueIdentifier, sender: indexPath.row)
    }
}
