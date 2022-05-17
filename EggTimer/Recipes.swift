//
//  Recipes.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  삶은 계란 레시피들

import Foundation

struct Recipes: Decodable {
    let title: String       // 제목
    let link: String        // 블로그 링크
    let description: String // 요약 내용
}
