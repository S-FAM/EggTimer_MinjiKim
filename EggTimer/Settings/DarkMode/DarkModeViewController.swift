//
//  DarkModeViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/28.
//

import Foundation
import UIKit

final class DarkModeViewController: UIViewController {
    static let identifier = "DarkModeViewController"
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "다크 모드"
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

extension DarkModeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DarkModeCell.identifier) as? DarkModeCell else { return UITableViewCell() }
        
        cell.update(indexPath.row, DarkModeManager.getAppearance())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DarkModeManager.setApperance(mode: .light)
        } else {
            DarkModeManager.setApperance(mode: .dark)
        }
        
        setupAppearance()
        tableView.reloadData()
    }
}
