//
//  RecipeCell.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  레시피 화면 테이블 뷰 셀

import UIKit

final class RecipeCell: UITableViewCell {
    static let identifier = "RecipeCell"
    
    func update() {
        textLabel?.text = "편스토랑 류수영 어남선생 호랑이달걀 레시피 계란튀김 삶은계란요리"
        detailTextLabel?.text = "레시피 요약 1 달걀은 소금1큰술, 식초 1큰술을 넣고 7분간 삶아주세요 2 껍질을 벗겨 물기를 제거하고 칼집을 냅니다 3 190도 기름에 5분간 튀기면 호랑이달걀 완성!"
    }
}
