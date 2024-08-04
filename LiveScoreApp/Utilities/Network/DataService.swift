//
//  DataService.swift
//  HooleyAPIs
//
//  Created by Usama Sadiq on 1/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
//import GoogleSignIn

class DataService {
    
    static let shared = DataService()
    
    var categoryList: [Category] = [Category]()
    
    func fetchData(fromURL urlStr:String,parameters:Dictionary<String,Any>,completionHandler:@escaping (_ error:Error?, _ json:Dictionary<String,Any>?)->Void) -> Void {

        let url = URL(string: urlStr)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            if let error = error{
                completionHandler(error, nil)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(nil, json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(error, nil)
                }
            }
        })

        task.resume()
    }
    
    
    func fetchGetData(fromURL urlStr:String, parameters:Dictionary<String,Any>?, completionHandler:@escaping (_ error:Error?, _ json:Dictionary<String,Any>?)->Void) -> Void {

        guard let url = URL(string: urlStr) else{
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy =  ReachabilityTest.isConnectedToNetwork() ? .useProtocolCachePolicy : .returnCacheDataDontLoad

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            if let error = error{
                completionHandler(error, nil)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(nil, json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(error, nil)
                }
            }
        })
        task.resume()
    }
}

