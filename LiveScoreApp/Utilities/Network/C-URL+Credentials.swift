//
//  C-URL+Credentials.swift
//  easypeasy
//
//  Created by EXIA on 07/10/2020.
//

import Foundation
//BASE_URL = "http://ec2-54-221-37-200.compute-1.amazonaws.com/api/"
struct BaseUrl {
    static var Testing = "http://ec2-54-221-37-200.compute-1.amazonaws.com"
    static var DEV = "https://devappapi.movo.cash"
    static var STAGING = ""
    static var LIVE = "https://apiv2.allsportsapi.com"
}

let API_KEY = "cce63d8e7b3fcebf028147b708ad6dc3c608a98b85d0b33018acefbab4a53739"

var apiURL : String {
    return "\(BaseUrl.LIVE)"
}
//https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=!_your_account_APIkey_!
struct API {
    struct Leagues {
        struct Football {
            static let fixtures = "\(apiURL)/football/?met=Fixtures&APIkey=\(API_KEY)"
            static let allLeagues = "\(apiURL)/football/?met=Leagues&APIkey=\(API_KEY)"
            static let liveScore = "\(apiURL)/football/?met=Livescore&APIkey=\(API_KEY)"
            static let standings = "\(apiURL)/football/?met=Standings&APIkey=\(API_KEY)"
        }

        struct Baseball {
            static let allLeagues = "\(apiURL)/basketball/"
        }

    }

        
}

