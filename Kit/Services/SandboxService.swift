//
//  SandboxService.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/5/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import Alamofire
import RxSwift
import ObjectMapper
import CleanroomLogger

enum SandboxError: Error {
    case NoTokenError
    case GetTextError(String)
}

class SandboxService: NSObject {

    func getText() -> Observable<String> {
        
        return Observable.create({ (observer) -> Disposable in
            
            guard let token = CredentialsStorage.token else {
                observer.on(.error(SandboxError.NoTokenError))
                return Disposables.create {}
            }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            let requestReference = Alamofire.request(Path.getText,
                                                     method: .get,
                                                     parameters: nil,
                                                     encoding: JSONEncoding.default,
                                                     headers: headers)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        let json = value as? [String : Any] ?? [:]
                        guard let serverResponse = Mapper<TextResponse>().map(JSON: json) else { return }
                        
                        if serverResponse.isSuccess {
                            observer.on(.next(serverResponse.text ?? "Test"))
                            observer.on(.completed)
                        } else {
                            let errorMessage = serverResponse.errors[0].message ?? "GetText error"
                            observer.on(.error(SandboxError.NoTokenError))
                            Log.error?.message("GetText error \(errorMessage)")
                        }
                        
                    case .failure(let error):
                        Log.error?.message("GetText error \(error.localizedDescription)")
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
