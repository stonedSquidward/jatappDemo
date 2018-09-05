//
//  AuthorizationService.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import Alamofire
import RxSwift
import ObjectMapper
import CleanroomLogger

enum AuthorizationError: Error {
    case LoginError(String)
    case SignupError(String)
}

struct Path {
    private init() {}
    private static var baseURL = "http://apiecho.cf/api/"
    
    static let login = "\(baseURL)login/"
    static let signup = "\(baseURL)signup/"
    
    static let getText = "\(baseURL)get/text/"
}

class AuthorizationService: NSObject {

    static let sharedInstance = AuthorizationService()
    
    func login(email:String, password: String) -> Observable<UserResponse> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let requestReference = Alamofire.request(Path.login,
                                                     method: .post ,
                                                     parameters: ["email": email,
                                                                  "password": password],
                                                     encoding: JSONEncoding.default,
                                                     headers: nil)
                .responseJSON(completionHandler: { (response) in
                    
                    Log.debug?.message("Login server response = \(response)")
                    
                    switch response.result {
                    case .success(let value):
                       
                        let json = value as? [String : Any] ?? [:]
                        guard let serverResponse = Mapper<BaseModel<UserResponse>>().map(JSON: json) else { return }
                        
                        if serverResponse.isSuccess {
                            guard let loginData = serverResponse.data else {
                                observer.on(.error(AuthorizationError.LoginError("Empty response")))
                                Log.error?.message("Login data is empty")
                                return
                            }
                            CredentialsStorage.token = loginData.accessToken
                            observer.on(.next(loginData))
                            observer.on(.completed)
                        } else {
                            let errorMessage = serverResponse.errors[0].message ?? "Login error"
                            observer.on(.error(AuthorizationError.LoginError(errorMessage)))
                            Log.error?.message("Login error \(errorMessage)")
                        }
                        
                    case .failure(let error):
                        Log.error?.message("Login error \(error.localizedDescription)")
                        observer.on(.error(error))
                        return
                    }
                })
            
            return Disposables.create {
                return requestReference.cancel()
            }
        })
    }
    
    func signup(name: String, email:String, password: String) -> Observable<UserResponse> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let requestReference = Alamofire.request(Path.signup,
                                                     method: .post ,
                                                     parameters: [ "name": name,
                                                                   "email": email,
                                                                   "password": password],
                                                     encoding: JSONEncoding.default,
                                                     headers: nil)
                .responseJSON(completionHandler: { (response) in
                    
                    Log.debug?.message("Signup server response = \(response)")
                    
                    switch response.result {
                    case .success(let value):
                        
                        let json = value as? [String : Any] ?? [:]
                        guard let serverResponse = Mapper<BaseModel<UserResponse>>().map(JSON: json) else { return }
                        
                        if serverResponse.isSuccess {
                            guard let loginData = serverResponse.data else {
                                observer.on(.error(AuthorizationError.SignupError("Empty response")))
                                Log.error?.message("Signup data is empty")
                                return
                            }
                            CredentialsStorage.token = loginData.accessToken
                            observer.on(.next(loginData))
                            observer.on(.completed)
                        } else {
                            let errorMessage = serverResponse.errors[0].message ?? "Login error"
                            observer.on(.error(AuthorizationError.SignupError(errorMessage)))
                            Log.error?.message("Signup error \(errorMessage)")
                        }
                        
                    case .failure(let error):
                        Log.error?.message("Signup error \(error.localizedDescription)")
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
