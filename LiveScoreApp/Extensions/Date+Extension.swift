//
//  Date+Extension.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 27/07/2024.
//

import Foundation

extension Date {
    func getFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current  // Set the timezone if needed

        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
