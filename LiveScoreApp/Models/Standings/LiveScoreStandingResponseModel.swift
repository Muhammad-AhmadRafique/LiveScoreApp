//
//  LiveScoreStandingResponseModel.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 28/07/2024.
//

import Foundation


// MARK: - LiveScoreStandingResponseModel
struct LiveScoreStandingResponseModel: Codable {
    let success: Int?
    let result: LiveScoreStandingAPIModel?
}

// MARK: - Result
struct LiveScoreStandingAPIModel: Codable {
    let total, home, away: [LiveScoreStandingModel]?
}

// MARK: - Away
struct LiveScoreStandingModel: Codable {
    let standingPlace: Int?
    let standingPlaceType: String?
    let standingTeam: String?
    let standingP, standingW, standingD, standingL: Int?
    let standingF, standingA, standingGD, standingPTS: Int?
    let teamKey, leagueKey: Int?
    let leagueSeason: String?
    let leagueRound: String?
    let standingUpdated: String?
    let fkStageKey: Int?
    let stageName: String?
    let teamLogo: String?
    let standingLP, standingWP: Int?

    enum CodingKeys: String, CodingKey {
        case standingPlace = "standing_place"
        case standingPlaceType = "standing_place_type"
        case standingTeam = "standing_team"
        case standingP = "standing_P"
        case standingW = "standing_W"
        case standingD = "standing_D"
        case standingL = "standing_L"
        case standingF = "standing_F"
        case standingA = "standing_A"
        case standingGD = "standing_GD"
        case standingPTS = "standing_PTS"
        case teamKey = "team_key"
        case leagueKey = "league_key"
        case leagueSeason = "league_season"
        case leagueRound = "league_round"
        case standingUpdated = "standing_updated"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case teamLogo = "team_logo"
        case standingLP = "standing_LP"
        case standingWP = "standing_WP"
    }
}
