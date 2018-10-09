//
//  TextTableViewController.swift
//  JatAppDemo
//
//  Created by HavanRoman on 9/5/18.
//  Copyright © 2018 JatApp. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class NumberOfLettersTableViewController: UITableViewController {

    // MARK: - Properties
    private let viewModel = NumberOfLettersViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    static func create() -> NumberOfLettersTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! NumberOfLettersTableViewController
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
        
        viewModel.isUpdateTableView.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            if value {
                strongSelf.tableView.reloadData()
            }
            }.disposed(by: disposeBag)
        
//        viewModel.goToLogin.asObservable().bind { [weak self] value in
//            guard let strongSelf = self else { return }
//
//            if value {
//                let vc = LoginViewController.create()
//                strongSelf.present(vc, animated: true)
//            }
//            }.disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.goToLogin.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            if value {
                let vc = LoginViewController.create()
                strongSelf.present(vc, animated: true)
            }
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dictionary.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let ch = Array(viewModel.dictionary.keys)[indexPath.row]
        let count = viewModel.dictionary[ch] ?? 0
        cell.textLabel?.text = "character = '\(ch)', count = \(count)"

        return cell
    }
}
