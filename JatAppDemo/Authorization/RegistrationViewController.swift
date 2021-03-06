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
    
    // MARK: - Life cycle
    
    static func create() -> RegistrationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! RegistrationViewController
        
        return vc;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        nameTextField.text = "testIos"
        emailTextField.text = "tetsIos333333@gmail.com"
        passwordTextField.text = "qwerty123"
        #endif
        
        viewModel.isLoadingContent.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            if value {
                MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
            } else {
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
            }
            }.disposed(by: disposeBag)
        
        viewModel.goToNextScreen.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            if value {
                let vc = TextViewController.create()
                strongSelf.present(vc, animated: true)
            }
            }.disposed(by: disposeBag)
        
        viewModel.showErrorAlertMessage.asObservable().skip(1).bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController.errorAlert(message: value)
            strongSelf.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - IBActions
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        viewModel.signup(name: name, email: email, password: password)
    }
    @IBAction func backToLoginButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
