//
//  ServerError.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import ObjectMapper

public class ServerError: Mappable {
    var name: String
    var message: String?
    
    public required init?(map: Map) {
        guard let name = map.JSON["name"] as? String else {
            return nil
        }
        self.name = name
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        message <- map["message"]
    }
}
