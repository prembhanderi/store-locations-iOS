//
//  APIClient.swift
//  Locations Client
//
//  Created by rb on 6/18/19.
//  Copyright © 2019 premBhanderi. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    static var accessToken = ""
    
    static func register(withUsername username: String, password: String) {
        print("Sending request")
        
        let parameters: Parameters = ["username": username, "password": password]
        
        AF.request("http://127.0.0.1:5000/register", method: .post, parameters: parameters).responseJSON { response in
            
            var jsonData = [String: AnyObject]()
            switch response.result {
                case let .success(value): jsonData = value as! [String : AnyObject]
                case let .failure(error): print("ERROR: \(error)")
            }
        }
    }
    
    static func login(withUsername username: String, password: String, completion: @escaping () -> Void) {
        print("Sending request")
        
        let parameters: Parameters = ["username": username, "password": password]
        AF.request("http://127.0.0.1:5000/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            var jsonData = [String: AnyObject]()
            switch response.result {
                case let .success(value): jsonData = value as! [String : AnyObject]
                case let .failure(error): print("ERROR: \(error)")
            }
            
            if let access_token = jsonData["access_token"] {
                print("Access token is: \(access_token)")
                accessToken = access_token as! String
                UserDefaults.standard.set(access_token, forKey: "access_token")
            }
        }
        
        completion()
    }
    
    static func getLocations(completion: @escaping (_ locations: [(name: String, groupName: String)]) -> Void) {
        AF.request("http://127.0.0.1:5000/locations", method: .get).responseJSON { response in
            
            var jsonData = [String: AnyObject]()
            switch response.result {
                case let .success(value): jsonData = value as! [String : AnyObject]
                case let .failure(error): print("ERROR: \(error)")
            }
            var locationsToReturn = [(name: String, groupName: String)]()
            if let locations = jsonData["locations"] as? [[String: AnyObject]] {
                for location in locations {
                    locationsToReturn.append((name: location["name"] as! String, groupName: location["group"] as! String))
                }
            }
            completion(locationsToReturn)
        }
    }
    
    static func addGroup(groupName: String){
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(accessToken)"
        ]
        
        AF.request("http://127.0.0.1:5000/group/\(groupName)", method: .post, headers: headers)
        
        
    }
    
    static func addLocation(locationName: String){
        let headers: HTTPHeaders = [
            "Authorization": "JWT \(accessToken)"
        ]
        
        AF.request("https://127.0.0.1:5000/student/\(locationName)", parameters: ["username": "t", "password": "t", "group_id": 1], headers: headers).validate(contentType: ["application/json"])
    }
}
