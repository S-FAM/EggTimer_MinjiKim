//
//  RecipeCell.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  레시피 화면 테이블 뷰 셀

import UIKit

final class RecipeCell: UITableViewCell {
    static let identifier = "RecipeCell"
    
    func update(_ recipe: Recipes) {
        textLabel?.text = recipe.title.htmlEscaped
        detailTextLabel?.text = recipe.description.htmlEscaped
    }
}
