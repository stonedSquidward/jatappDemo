//
//  TextViewController.swift
//  JatAppDemo
//
//  Created by HavanRoman on 10/8/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    private let viewModel = TextViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    static func create() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TextViewControllerNavigationController") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.isLoadingContent.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            if value {
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            } else {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
            }
            }.disposed(by: disposeBag)
        
        viewModel.getText()
        
        viewModel.text.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            strongSelf.textView.text = value
            }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.goToLogin.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            if value { strongSelf.goToLogin() }
            }.disposed(by: disposeBag)
    }

    @IBAction func refreshTextButtonAction(_ sender: UIBarButtonItem) {
        viewModel.getText()
    }
    
    @IBAction func goToNumberOfLettersAction(_ sender: Any) {
    
    }
    
    @IBAction func logoutButtonAction(_ sender: UIBarButtonItem) {
        CredentialsStorage.token = nil;
        goToLogin()
    }
    
    //Private
    private func goToLogin() {
        let vc = LoginViewController.create()
        self.present(vc, animated: true)
    }
}
