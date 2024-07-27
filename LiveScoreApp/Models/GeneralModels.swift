//
//  GeneralModels.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 24/07/2024.
//

import Foundation

enum ResponseType : Int {
    case success = 1
    case error = 0
}

struct CustomError: LocalizedError {
    var description: String?

    init(description: String) {
        self.description = description
    }
}

struct NotSuccessModel:Codable {
    let isError: Bool
    let messages: String?
}
