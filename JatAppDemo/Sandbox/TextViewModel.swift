//
//  TextViewModel.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/5/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import RxSwift
import CleanroomLogger

class TextViewModel {
    
    var isLoadingContent: Variable<Bool> = Variable(false)
    var isUpdateTableView: Variable<Bool> = Variable(false)
    
    var dictionary = [Character: Int]()
    
    var sandboxService = SandboxService()
    
    func getText() {
        isLoadingContent.value = true
        
        _ = sandboxService.getText().subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            
            switch event {
            case .next(let value):
                Log.debug?.message("TextViewModel TEXT = \(value)")
                
                strongSelf.countNumberOfCharacters(text: value)
            case .error(let error):
                Log.debug?.message("TextViewModel ERROR = \(error.localizedDescription)")
            case .completed:
                break
            }
            
            strongSelf.isLoadingContent.value = false

        }
    }
    
    private func countNumberOfCharacters(text: String) {
        text.forEach { character in
            if dictionary[character] == nil {
                dictionary[character] = 1
            } else {
                let count = dictionary[character] ?? 0
                dictionary[character] = count + 1
            }
        }
        isUpdateTableView.value = true
    }
}
