//
//  LiveOddsResponseModel.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 28/07/2024.
//

import Foundation

// MARK: - LiveOddsResponseModel
struct LiveOddsResponseModel: Codable {
    let success: Int?
    let result: [String: [LiveOddModel]]?
}

// MARK: - Result
struct LiveOddModel: Codable {
    let oddName: String?
    let isOddSuspended: String?
    let oddType, oddValue: String?
    let oddParticipantHandicap: String?
    let oddLastUpdated: String?
    let matchID: Int?

    enum CodingKeys: String, CodingKey {
        case oddName = "odd_name"
        case isOddSuspended = "is_odd_suspended"
        case oddType = "odd_type"
        case oddValue = "odd_value"
        case oddParticipantHandicap = "odd_participant_handicap"
        case oddLastUpdated = "odd_last_updated"
        case matchID = "match_id"
    }
}
