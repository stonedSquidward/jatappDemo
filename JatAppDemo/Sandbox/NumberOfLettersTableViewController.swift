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

class NumberOfLettersTableViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = NumberOfLettersViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    static func create(text: String) -> NumberOfLettersTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! NumberOfLettersTableViewController
        vc.viewModel.countNumberOfCharacters(text: text)
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.isUpdateTableView.asObservable().bind { [weak self] value in
            guard let strongSelf = self else { return }
            
            if value {
                strongSelf.tableView.reloadData()
            }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Table view data source

extension NumberOfLettersTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let ch = Array(viewModel.dictionary.keys)[indexPath.row]
        let count = viewModel.dictionary[ch] ?? 0
        cell.textLabel?.text = "character = '\(ch)', count = \(count)"
        
        return cell
    }
}

extension NumberOfLettersTableViewController: UITableViewDelegate {
    
}


