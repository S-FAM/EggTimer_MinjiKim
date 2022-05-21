//
//  RecipeDetailViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  삶은 계란 레시피 상세 화면 뷰 컨트롤러

import NVActivityIndicatorView
import UIKit
import WebKit

final class RecipeDetailViewController: UIViewController {
    var recipe: Recipes?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var networkLabel: UILabel!
    
    private lazy var indicator = NVActivityIndicatorView(
        frame: CGRect(
            x: (view.bounds.width / 2) - 15,
            y: (view.bounds.height / 2) + 65 ,
            width: 30,
            height: 30
        ),
        type: .ballPulseSync,
        color: .systemBackground,
        padding: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicator)

        indicator.startAnimating()
        checkNetwork()
    }
    
    @IBAction func leftSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    func checkNetwork() {
        NetworkCheck.shared.startMonitoring { [weak self] isConnect in
            guard let self = self else { return }

            if isConnect {
                guard let url = URL(string: self.recipe?.link ?? "") else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let urlRequest = URLRequest(url: url)
                    self.webView.load(urlRequest)
                    self.indicator.isHidden = true
                    self.networkLabel.isHidden = true
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.indicator.isHidden = true
                    self.networkLabel.isHidden = false
                }
            }
        }
    }
}
