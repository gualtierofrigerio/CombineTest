//
//  UsersTableViewControllerPW.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 02/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Combine
import UIKit

/// Display a list of users in a UITableView
/// uses Combine to have a @Published filter
/// and uses the @Filtered Property Wrapper to change
/// the users to display
class UsersTableViewControllerPW: UITableViewController {
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
        return _users.filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return makeCell(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = _users.filtered[indexPath.row]
        let album = user.albums?[0]
        let viewModel = PicturesCollectionVM()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PicturesCollectionVC") as? PicturesCollectionVC {
            vc.viewModel = viewModel
            viewModel.viewController = vc
            if #available(iOS 15.0.0, *) {
                viewModel.loadPictures(album?.pictures ?? [])
            }
            present(vc, animated: true)
        }
    }
    
    // MARK: - Private
    private func applyFilter(_ filter:String) {
        _users.filter = filter
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
        
        if indexPath.row < _users.filtered.count {
            let user = _users.filtered[indexPath.row]
            cell.textLabel?.text = user.username
        }
        
        return cell
    }
}

// MARK: - UISearchControllerDelegate

extension UsersTableViewControllerPW : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filter = searchText
        }
        else {
            filter = ""
        }
    }
}
