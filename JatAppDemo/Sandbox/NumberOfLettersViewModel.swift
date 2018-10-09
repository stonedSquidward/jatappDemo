//
//  TextViewModel.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/5/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import RxSwift
import CleanroomLogger

class NumberOfLettersViewModel {
    
    var isUpdateTableView: Variable<Bool> = Variable(false)
    var dictionary = [Character: Int]()
   
    var sandboxService = SandboxService()
    
    private let disposeBag = DisposeBag()
    
    func countNumberOfCharacters(text: String) {
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
