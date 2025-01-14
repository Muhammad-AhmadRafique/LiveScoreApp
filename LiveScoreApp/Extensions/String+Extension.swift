//
//  String+Extension.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import Foundation

extension String {
    func countryFlag() -> String {
        let countryCode = self == "UK" ? "GB" : self
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in countryCode.utf16 {
            if let uniCode = UnicodeScalar(base + Int(i)) {
                usv.append(uniCode)
            } else {
                return ""
            }
        }
        return String(usv)
    }
}
