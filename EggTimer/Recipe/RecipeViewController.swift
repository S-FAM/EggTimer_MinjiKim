//
//  RecipeViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  레시피 화면 뷰 컨트롤러

import NVActivityIndicatorView
import UIKit

final class RecipeViewController: UIViewController {
    private let viewModel = RecipeViewModel()
    
    /// RecipeDetailViewController를 push하는 Segue의 identifier
    private let segueIdentifier = "pushToRecipeDetail"

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var networkLabel: UILabel!
    
    private lazy var indicator = NVActivityIndicatorView(
        frame: CGRect(
            x: (view.bounds.width / 2) - 15,
            y: (view.bounds.height / 2) + 65 ,
            width: 30,
            height: 30
        ),
        type: .ballPulseSync,
        color: .systemGray,
        padding: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicator)

        indicator.startAnimating()
        checkNetwork()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAppearance()
    }
    
    func setupAppearance() {
        DarkModeManager.applyAppearance(
            mode: DarkModeManager.getAppearance(),
            viewController: self
        )
    }
    
    /// 세그웨이 실행되면 선택된 레시피를 상세화면으로 넘겨주면서 push 하기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let vc = segue.destination as? RecipeDetailViewController
            
            if let row = sender as? Int {
                let recipe = viewModel.recipeInfo(at: row)
                vc?.recipe = recipe
            }
        }
    }
    
    /// 네트워크 연결 확인하기
    func checkNetwork() {
        NetworkCheck.shared.startMonitoring { [weak self] isConnect in
            guard let self = self else { return }

            if isConnect {
                self.viewModel.requestRecipesList {
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                        self.networkLabel.isHidden = true   // TODO: 함수로 바꿔보기(isConnect 파라미터로 받기)
                        self.tableview.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                    self.networkLabel.isHidden = false
                }
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
        guard (currentRow % display) == (display - 3) &&
                (currentRow / display) == (currentPage - 1) else { return }
        
        viewModel.requestRecipesList {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.tableview.reloadData()
            }
        }
    }
    
    /// 셀이 클릭되었을 때
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: segueIdentifier, sender: indexPath.row)
    }
}
