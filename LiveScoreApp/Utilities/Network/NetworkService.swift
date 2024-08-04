//
//  DataService.swift
//  HooleyAPIs
//
//  Created by Usama Sadiq on 1/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

enum RequestType:String {
    
    case post = "POST"
    case get = "GET"
}
typealias Parameters = Dictionary<String,Any>

let session = URLSession.shared

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetchData(requestType:RequestType,fromURL urlStr:String,parameters:Dictionary<String,Any>,completionHandler:@escaping (_ error:Error?, _ jsonData:Data?, _ statusCode:Int?)->Void) -> Void {

        guard let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        if requestType.rawValue == RequestType.post.rawValue{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }else{
            request.cachePolicy =  ReachabilityTest.isConnectedToNetwork() ? .useProtocolCachePolicy : .returnCacheDataDontLoad
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("ja", forHTTPHeaderField: "Accept-Language")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            var statusCode : Int?

            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                print("statusCode: \(httpResponse.statusCode)")
                
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 401 {
                        print("Logout")
                    }
                }
            }
            
            if let error = error{
                completionHandler(error, nil, statusCode)
            }else{
                completionHandler(nil, data, statusCode)
            }
        })
        
        task.resume()
        
    }
}


