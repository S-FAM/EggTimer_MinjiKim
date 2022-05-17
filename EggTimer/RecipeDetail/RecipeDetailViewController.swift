//
//  RecipeDetailViewController.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  삶은 계란 레시피 상세 화면 뷰 컨트롤러

import UIKit
import WebKit

final class RecipeDetailViewController: UIViewController {
    var recipe: Recipes?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: recipe?.link ?? "") else {
            //되돌아가기
            return
        }
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    @IBAction func leftSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    // TODO: 네트워크 연결안될 때 처리
}
