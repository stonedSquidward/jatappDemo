//
//  AuthorizationService.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import ObjectMapper
import CleanroomLogger

enum AuthorizationError: Error {
    case LoginError(String)
}


struct Path {
    
    private init() {}
    private static var baseURL = "http://apiecho.cf/api/"
    
    static let login = "\(baseURL)login/"
}

class AuthorizationService: NSObject {

    func login(email:String, password: String) -> Observable<UserResponse> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let requestReference = Alamofire.request(Path.login,
                                                     method: .post ,
                                                     parameters: ["email": email,
                                                                  "password": password],
                                                     encoding: JSONEncoding.default,
                                                     headers: nil)
                .responseJSON(completionHandler: { (response) in
                    
                    Log.debug?.message("Server response = \(response)")
                    
                    switch response.result {
                    case .success(let value):
                       
                        let json = value as? [String : Any] ?? [:]
                        guard let serverResponse = Mapper<BaseModel<UserResponse>>().map(JSON: json) else { return }
                        
                        if serverResponse.isSuccess {
                            guard let loginData = serverResponse.data else {
                                observer.on(.error(AuthorizationError.LoginError("Empty response")))
                                Log.error?.message("Data is empty")
                                return
                            }
                            
                            CredentialsStorage.token = loginData.accessToken
                            observer.on(.next(loginData))
                            observer.on(.completed)
                        } else {
                            let errorMessage = serverResponse.errors[0].message ?? "Login error"
                            observer.on(.error(AuthorizationError.LoginError(errorMessage)))
                            Log.error?.message("login error \(errorMessage)")
                        }
                        
                    case .failure(let error):
                        Log.error?.message("login error \(error.localizedDescription)")
                        observer.on(.error(error))
                        return
                    }
                })
            
            return Disposables.create {
                return requestReference.cancel()
            }
        })
    }
    
}
