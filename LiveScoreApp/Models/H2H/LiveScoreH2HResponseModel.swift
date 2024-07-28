//
//  LiveScoreH2HResponseModel.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 28/07/2024.
//

import Foundation

// MARK: - LiveScoreH2HResponseModel
struct LiveScoreH2HResponseModel: Codable {
    let success: Int?
    let result: H2HApiModel?
}

// MARK: - Result
struct H2HApiModel: Codable {
    let h2H, firstTeamResults, secondTeamResults: [H2HModel]?

    enum CodingKeys: String, CodingKey {
        case h2H = "H2H"
        case firstTeamResults, secondTeamResults
    }
}

// MARK: - H2H
struct H2HModel: Codable {
    let eventKey: Int?
    let eventDate, eventTime, eventHomeTeam: String?
    let homeTeamKey: Int?
    let eventAwayTeam: String?
    let awayTeamKey: Int?
    let homeTeamLogo, awayTeamLogo: String?
    let eventHalftimeResult, eventFinalResult: String?
    let eventStatus: String?
    let countryName: String?
    let leagueName: String?
    let leagueKey: Int?
    let leagueRound, leagueSeason, eventLive: String?
    let eventCountryKey: Int?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventCountryKey = "event_country_key"
    }
}
