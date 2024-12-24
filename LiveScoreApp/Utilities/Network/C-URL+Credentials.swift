//
//  C-URL+Credentials.swift
//  easypeasy
//
//  Created by EXIA on 07/10/2020.
//

import Foundation
//BASE_URL = "http://ec2-54-221-37-200.compute-1.amazonaws.com/api/"
struct BaseUrl {
    static var STAGING = ""
    static var LIVE = "https://apiv2.allsportsapi.com"
}

let API_KEY = "your_api_key"

var apiURL : String {
    return "\(BaseUrl.LIVE)"
}
//https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=!_your_account_APIkey_!
let language = "vi"
struct API {
    struct Leagues {
        struct Football {
            static let fixtures = "\(apiURL)/football/?met=Fixtures&APIkey=\(API_KEY)&lang=\(language)"
            static let allLeagues = "\(apiURL)/football/?met=Leagues&APIkey=\(API_KEY)&lang=\(language)"
            static let liveScore = "\(apiURL)/football/?met=Livescore&APIkey=\(API_KEY)&lang=\(language)"
            static let standings = "\(apiURL)/football/?met=Standings&APIkey=\(API_KEY)&lang=\(language)"
            static let h2h = "\(apiURL)/football/?met=H2H&APIkey=\(API_KEY)&lang=\(language)"
            static let liveOdds = "\(apiURL)/football/?met=OddsLive&APIkey=\(API_KEY)&lang=\(language)"
        }

        struct Baseball {
            static let allLeagues = "\(apiURL)/basketball/"
        }

    }
        
}

