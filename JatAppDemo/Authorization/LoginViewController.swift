//
//  LoginViewController.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        emailTextField.text = "tetsIos123@gmail.com"
        passwordTextField.text = "qwerty123"
        #endif
        
        _ = viewModel.isLoadingContent.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            if value {
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            } else {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
            }
        }
        
        _ = viewModel.goToNextScreen.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            if value {
                let vc = TextTableViewController.create()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let pass = passwordTextField.text else { return }
        
        viewModel.login(email: email, password: pass)
    }
}
