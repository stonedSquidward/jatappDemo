//
//  UserResponse.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import ObjectMapper

class UserResponse: Mappable {
   
    public var id: Int
    public var accessToken: String
    public var name: String?
    public var email: String?
    public var role: Int?
    
    public required init?(map: Map) {
        guard
            let id = map.JSON["uid"] as? Int,
            let accessToken = map.JSON["access_token"] as? String else {
                return nil
        }
        
        self.id = id
        self.accessToken = accessToken
    }
    
    public func mapping(map: Map) {
        id <- map["uid"]
        accessToken <- map["access_token"]
        name <- map["name"]
        email <- map["email"]
        role <- map["role"]
    }
}
