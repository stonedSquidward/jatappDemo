//
//  RegistrationViewModel.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//


import RxSwift
import CleanroomLogger

class RegistrationViewModel {
 
    var isLoadingContent: Variable<Bool> = Variable(false)
    
    var authorizationService = AuthorizationService.sharedInstance
    
    func signup(name: String, email: String, password: String) {
        isLoadingContent.value = true
        
        authorizationService
            .signup(name: name, email: email, password: password)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .next(let value):
                    Log.debug?.message("RegistrationViewModel TOKEN = \(value.accessToken)")
                case .error(let error):
                    Log.debug?.message("RegistrationViewModel ERROR = \(error.localizedDescription)")
                case .completed:
                    break
                }
                
                strongSelf.isLoadingContent.value = false
        }
    }
}
