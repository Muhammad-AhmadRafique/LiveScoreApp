//
//  LeaguesResponseModel.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 27/07/2024.
//

import Foundation

// MARK: - LeaguesResponseModel
struct LeaguesResponseModel: Codable {
    let success: Int?
    let result: [LeagueModel]?
}

// MARK: - Result
struct LeagueModel: Codable {
    let leagueKey, countryKey: Int?
    let leagueName, countryName: String?
    let leagueLogo, countryLogo: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
    }
}
