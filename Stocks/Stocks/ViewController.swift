//
//  ViewController.swift
//  Stocks
//
//  Created by Konstantin on 01.05.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService.shared.loadCompanies { [weak self] (companies, error) in
            print(companies)
            print(error)
        }
    }


}

