//
//  HelperFunctions.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 27/07/2024.
//

import Foundation

class Helper {
    static func groupLiveScoreMatchesByLeagues(list: [LiveScoreModel]) -> [LiveScoreLeagueModel] {
        var leagueDict = [Int: LiveScoreLeagueModel]()
        
        for match in list {
            guard let leagueKey = match.leagueKey,
                  let leagueName = match.leagueName else {
                continue
            }
            
            if var leagueModel = leagueDict[leagueKey] {
                leagueModel.matchList?.append(match)
                leagueDict[leagueKey] = leagueModel
            } else {
                let newLeagueModel = LiveScoreLeagueModel(leagueKey: leagueKey, leagueName: leagueName, matchList: [match], leagueLogo: match.leagueLogo ?? "")
                leagueDict[leagueKey] = newLeagueModel
            }
        }
        
        return Array(leagueDict.values)
    }
}
