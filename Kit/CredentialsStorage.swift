//
//  CredentialsStorage.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import KeychainAccess
import CleanroomLogger

class CredentialsStorage: NSObject {
    
    private static var serviceName: String { return "JatApp.Credentials" }
    private static var tokenKey: String { return "\(self.serviceName).token" }
    
    private static let keychain = Keychain(service: serviceName)
    
    static var token: String? {
        get {
            guard let token = keychain[tokenKey] else {
                return nil
            }
            
            return token
        }
        set(token) {
            guard let token = token else {
                do {
                    try keychain.remove(tokenKey)
                } catch {
                    Log.error?.message("Cannot remove non-existent object from keychain")
                }
                return
            }
            keychain[tokenKey] = token
        }
    }
    
}
