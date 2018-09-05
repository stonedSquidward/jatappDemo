//
//  BaseModel.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import Foundation
import ObjectMapper

public class BaseModel<T:Mappable>: Mappable {

    public var isSuccess: Bool
    public var data: T?
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
        data <- map["data"]
        errors <- map["errors"]
    }
}
