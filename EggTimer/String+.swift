//
//  String+.swift
//  EggTimer
//
//  Created by 김민지 on 2022/05/17.
//  String 확장 관련

import Foundation

extension String {
    /// html 태그 제거
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else { return self }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let attributed = try NSAttributedString(
                data: encodedData,
                options: options,
                documentAttributes: nil
            )
            return attributed.string
        } catch {
            return self
        }
    }
}
