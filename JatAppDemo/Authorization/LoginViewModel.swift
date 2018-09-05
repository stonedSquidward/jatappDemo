//
//  LoginViewModel.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import RxSwift
import CleanroomLogger

class LoginViewModel {

    var isLoadingContent: Variable<Bool> = Variable(false)
    var goToNextScreen: Variable<Bool> = Variable(false)
    var showErrorAlertMessage: Variable<String> = Variable("")
    
    var authorizationService = AuthorizationService.sharedInstance
    
    func login(email: String, password: String) {
        isLoadingContent.value = true
        
        authorizationService
            .login(email: email, password: password)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .next(let value):
                    Log.debug?.message("LoginViewModel TOKEN = \(value.accessToken)")
                    strongSelf.goToNextScreen.value = true
                case .error(AuthorizationError.LoginError(let errorMessage)):
                    Log.debug?.message("LoginViewModel ERROR = \(errorMessage)")
                    strongSelf.showErrorAlertMessage.value = errorMessage
                case .completed:
                    break
                case .error(_):
                    break
                }
                
               strongSelf.isLoadingContent.value = false
        }
    }
    
}
