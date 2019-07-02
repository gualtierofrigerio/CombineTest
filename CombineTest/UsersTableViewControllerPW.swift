//
//  UsersTableViewControllerPW.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 02/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Combine
import UIKit

class UsersTableViewController: UITableViewController {
    
    @Published var filter = ""
    @Filtered(initialFilter:"") var users:[User]
    let cellIdentifier = "CellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchViewController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func setUsers(_ users:[User]) {
        self.users = users
        _ = $filter.sink { value in
            self.applyFilter(value)
        }
        filter = ""
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return $users.filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeCell(indexPath: indexPath)
    }
}

// MARK: - UISearchControllerDelegate

extension UsersTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filter = searchText
        }
        else {
            filter = ""
        }
    }
}

// MARK: - Private

extension UsersTableViewController {
    private func applyFilter(_ filter:String) {
        $users.filter = filter
        tableView.reloadData()
    }
    
    private func configureSearchViewController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func makeCell(indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if indexPath.row < $users.filtered.count {
            let user = $users.filtered[indexPath.row]
            cell.textLabel?.text = user.username
        }
        
        return cell
    }
}
