//
//  RegistrationViewController.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/4/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Properties
    
    private let viewModel = RegistrationViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        nameTextField.text = "testIos"
        emailTextField.text = "tetsIos333333@gmail.com"
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
        
        _ = viewModel.showErrorAlertMessage.asObservable().skip(1).bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController.errorAlert(message: value)
            strongSelf.present(alert, animated: true)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        viewModel.signup(name: name, email: email, password: password)
    }
}
