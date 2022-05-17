//
//  RecipesResponseModel.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  삶은 계란 레시피 응답 모델(Naver API)

import Foundation

struct RecipesResponseModel: Decodable {
    var items: [Recipes] = []
}

// Naver 블로그 API: https://developers.naver.com/docs/serviceapi/search/blog/blog.md#블로그
