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
    
    static func groupH2HScoreMatchesByLeagues(list: [H2HModel]) -> [LiveScoreH2HLeagueModel] {
        var leagueDict = [Int: LiveScoreH2HLeagueModel]()
        
        for match in list {
            guard let leagueKey = match.leagueKey,
                  let leagueName = match.leagueName else {
                continue
            }
            
            if var leagueModel = leagueDict[leagueKey] {
                leagueModel.matchList?.append(match)
                leagueDict[leagueKey] = leagueModel
            } else {
                let newLeagueModel = LiveScoreH2HLeagueModel(leagueKey: leagueKey, leagueName: leagueName, matchList: [match])
                leagueDict[leagueKey] = newLeagueModel
            }
        }
        
        return Array(leagueDict.values)
    }
    
    static func groupOddsScoreMatchesByMatch(list: [LiveOddModel]) -> [LiveScoreOddsMatchModel] {
        var oddsDict = [String: LiveScoreOddsMatchModel]()
        
        for odd in list {
            guard let oddName = odd.oddName else {
                continue
            }
            
            if var oddModel = oddsDict[oddName] {
               // do nothing
            } else {
                let newOddModel = LiveScoreOddsMatchModel(oddName: oddName, oddValue: odd)
                oddsDict[oddName] = newOddModel
            }
        }
        
        return Array(oddsDict.values)
    }
}
