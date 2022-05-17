//
//  RecipesRequestModel.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  삶은 계란 레시피 요청 모델(Naver API)

import Foundation

struct RecipesRequestModel: Codable {
    /// 검색 시작 위치(기본 1, 최대 1000)
    let start: Int
    /// 검색 결과 출력 건수(기본 10, 최대 100)
    let display: Int
    /// 검색어
    let query: String
}

// Naver 블로그 API: https://developers.naver.com/docs/serviceapi/search/blog/blog.md#블로그
