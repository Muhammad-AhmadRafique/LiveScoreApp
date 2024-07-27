//
//  Dictionary+Extension.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 24/07/2024.
//

import Foundation

extension Dictionary where Key:ExpressibleByStringLiteral {
    
    func convertToJSONString() -> String{
        var paramStr:String!
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: []) {
            paramStr = String(data: theJSONData,
                              encoding: .utf8)!
        }
        return paramStr
    }
}
