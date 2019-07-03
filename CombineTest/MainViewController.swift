//
//  MainViewController.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 27/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let dataSource = DataSource(baseURL:"https://jsonplaceholder.typicode.com")
    let dataSourcePW = DataSourcePW()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showUsersTap(_ sender: Any) {
        _ = dataSourcePW.getUsersWithMergedData().sink { users in
            DispatchQueue.main.async {
                let usersVC = UsersTableViewControllerPW()
                usersVC.setUsers(users)
                self.navigationController?.pushViewController(usersVC, animated: true)
            }
        }
    }
}
