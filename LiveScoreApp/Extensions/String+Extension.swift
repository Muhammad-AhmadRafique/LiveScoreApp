//
//  String+Extension.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import Foundation
import UIKit

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
    
    func isValidURL() -> Bool {
        let urlString = self
        guard let url = URL(string: urlString), isPNG() else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func isPNG() -> Bool {
        return self.lowercased().hasSuffix(".png")
    }
    
    func getNonLiveScoreDayMonth() -> String? {
        // Input date format
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Output date format
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMMM d"
        
        // Convert string to Date
        guard let date = inputDateFormatter.date(from: self) else {
            return nil
        }
        
        // Convert Date back to desired string format
        let outputString = outputDateFormatter.string(from: date)
        return outputString
    }
}
