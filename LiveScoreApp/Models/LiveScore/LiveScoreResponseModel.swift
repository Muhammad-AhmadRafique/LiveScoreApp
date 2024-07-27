//
//  LiveScoreResponseModel.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 27/07/2024.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let liveScoreResponseModel = try? JSONDecoder().decode(LiveScoreResponseModel.self, from: jsonData)

import Foundation

// MARK: - LiveScoreResponseModel
struct LiveScoreResponseModel: Codable {
    let success: Int?
    let result: [LiveScoreModel]?
}

// MARK: - Result
struct LiveScoreModel: Codable {
    let eventKey: Int?
    let eventDate, eventTime, eventHomeTeam: String?
    let homeTeamKey: Int?
    let eventAwayTeam: String?
    let awayTeamKey: Int?
    let eventHalftimeResult, eventFinalResult, eventFtResult, eventPenaltyResult: String?
    let eventStatus, countryName, leagueName: String?
    let leagueKey: Int?
    let leagueRound, leagueSeason, eventLive, eventStadium: String?
    let eventReferee: String?
    let homeTeamLogo, awayTeamLogo: String?
    let eventCountryKey: Int?
    let leagueLogo, countryLogo: String?
    let eventHomeFormation, eventAwayFormation: String?
    let fkStageKey: Int?
    let stageName: String?
    let goalscorers: [Goalscorer]?
    let cards: [Card]?
    let lineups: Lineups?
    let statistics: [Statistic]?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventFtResult = "event_ft_result"
        case eventPenaltyResult = "event_penalty_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventCountryKey = "event_country_key"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case eventHomeFormation = "event_home_formation"
        case eventAwayFormation = "event_away_formation"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case goalscorers, cards, lineups, statistics
    }
}

// MARK: - Goalscorer
struct Goalscorer: Codable {
    let time, homeScorer, homeScorerID, homeAssist: String?
    let homeAssistID, score, awayScorer, awayScorerID: String?
    let awayAssist, awayAssistID, info, infoTime: String?

    enum CodingKeys: String, CodingKey {
        case time
        case homeScorer = "home_scorer"
        case homeScorerID = "home_scorer_id"
        case homeAssist = "home_assist"
        case homeAssistID = "home_assist_id"
        case score
        case awayScorer = "away_scorer"
        case awayScorerID = "away_scorer_id"
        case awayAssist = "away_assist"
        case awayAssistID = "away_assist_id"
        case info
        case infoTime = "info_time"
    }
}

// MARK: - Lineups
struct Lineups: Codable {
    let homeTeam, awayTeam: Team?

    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

// MARK: - Team
struct Team: Codable {
    let startingLineups, substitutes: [StartingLineup]?
    let coaches: [Coach]?

    enum CodingKeys: String, CodingKey {
        case startingLineups = "starting_lineups"
        case substitutes, coaches
    }
}

// MARK: - Coach
struct Coach: Codable {
    let coache: String?
}

// MARK: - StartingLineup
struct StartingLineup: Codable {
    let player: String?
    let playerNumber, playerPosition, playerKey: Int?
    let infoTime: String?

    enum CodingKeys: String, CodingKey {
        case player
        case playerNumber = "player_number"
        case playerPosition = "player_position"
        case playerKey = "player_key"
        case infoTime = "info_time"
    }
}

// MARK: - Statistic
struct Statistic: Codable {
    let type, home, away: String?
}

// MARK: - Card
struct Card: Codable {
    let time, homeFault, card, awayFault: String?
    let info, homePlayerID, awayPlayerID, infoTime: String?

    enum CodingKeys: String, CodingKey {
        case time
        case homeFault = "home_fault"
        case card
        case awayFault = "away_fault"
        case info
        case homePlayerID = "home_player_id"
        case awayPlayerID = "away_player_id"
        case infoTime = "info_time"
    }
}
