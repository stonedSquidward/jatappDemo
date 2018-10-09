//
//  TextViewModel.swift
//  JatAppDemo
//
//  Created by HavanRoman on 10/8/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import RxSwift
import CleanroomLogger

class TextViewModel {
  
    var isLoadingContent: Variable<Bool> = Variable(false)
    var text: Variable<String> = Variable("")
    var goToLogin: Variable<Bool> = Variable(false)
    
    var sandboxService = SandboxService()
    
    private let disposeBag = DisposeBag()
    
    func getText() {
        isLoadingContent.value = true
        
        sandboxService.getText().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            
            switch event {
            case .next(let value):
                Log.debug?.message("TextViewModel TEXT = \(value)")
                strongSelf.text.value = value
            case.error(SandboxError.NoTokenError):
                Log.debug?.message("No token")
                strongSelf.goToLogin.value = true;
            case .error(let error):
                Log.debug?.message("TextViewModel ERROR = \(error.localizedDescription)")
            case .completed:
                break
            }
            
            strongSelf.isLoadingContent.value = false
            
            }.disposed(by: disposeBag)
    }
}
