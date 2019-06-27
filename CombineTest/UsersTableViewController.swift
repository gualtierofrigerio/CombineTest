//
//  UsersTableViewController.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 27/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    let cellIdentifier = "CellIdentifier"
    var filteredUsers = [User]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func setUsers(_ users:[User]) {
        self.users = users
        applyFilter("")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeCell(indexPath: indexPath)
    }
}

// MARK: - Private

extension UsersTableViewController {
    private func applyFilter(_ filter:String) {
        if filter.count > 0 {
            filteredUsers = users.filter({
                return $0.username.lowercased().contains(filter.lowercased())
            })
        }
        else {
            filteredUsers = users
        }
        tableView.reloadData()
    }
    
    private func makeCell(indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if indexPath.row < filteredUsers.count {
            let user = filteredUsers[indexPath.row]
            cell.textLabel?.text = user.username
        }
        
        return cell
    }
}
