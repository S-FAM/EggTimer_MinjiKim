//
//  RecipesSearchManager.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  네이버에서 '삶은 계란 레시피' 키워드가 들어간 블로그 검색

import Alamofire
import Foundation

protocol RecipesSearchManagerProtocol {
    func request(
        start: Int,
        display: Int,
        completionHandler: @escaping ([Recipe]) -> Void
    )
}

struct RecipesSearchManager: RecipesSearchManagerProtocol {
    func request(
        start: Int,
        display: Int,
        completionHandler: @escaping ([Recipe]) -> Void
    ) {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/blog.json") else { return }
        
        let parameters = RecipesRequestModel(start: start, display: display, query: "삶은 계란 레시피")
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": NaverAPIKey.id,
            "X-Naver-Client-Secret": NaverAPIKey.secret
        ]

        AF
            .request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: RecipesResponseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result.items)
                    print(result)
                case .failure(let error):
                    print(error)
                }
            }
            .resume()
    }
}
