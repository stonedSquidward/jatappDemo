//
//  TextResponse.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/5/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import Foundation
import ObjectMapper

class TextResponse: Mappable {

    public var isSuccess: Bool
    public var text: String?
    public var errors = [ServerError]()
    
    public required init?(map: Map) {
        guard
            let isSuccess = map.JSON["success"] as? Bool else {
                return nil
        }
        
        self.isSuccess = isSuccess
    }
    
    public func mapping(map: Map) {
        isSuccess <- map["success"]
        text <- map["data"]
        errors <- map["errors"]
    }
}
