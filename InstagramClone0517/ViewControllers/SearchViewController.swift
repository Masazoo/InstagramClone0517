//
//  SearchViewController.swift
//  InstagramClone0517
//
//  Created by mt on 2019/05/22.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
        
        setupSearchBar()
        doSearch()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "ユーザー名で検索する"
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.frame.size.width = view.frame.size.width - 60
        let searchBarItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchBarItem
    }
    
    func doSearch() {
        self.users.removeAll()
        self.tableView.reloadData()
        if let searchText = searchBar.text?.lowercased() {
            Api.User.queryUsers(text: searchText) { (user) in
                Api.Follow.isFollowing(uid: user.uid!, completion: { (value) in
                    user.isFollowing = value
                    guard Api.User.CURRENT_USER?.uid != user.uid else {
                        return
                    }
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToProfileUserSegue" {
            let userId = sender as! String
            let profileUserVC = segue.destination as! ProfileUserViewController
            profileUserVC.userId = userId
            profileUserVC.delegate = self
        }
    }
    
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        self.performSegue(withIdentifier: "SearchToProfileUserSegue", sender: user.uid)
    }
    
}
extension SearchViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        self.performSegue(withIdentifier: "SearchToProfileUserSegue", sender: userId)
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        doSearch()
    }
}
extension SearchViewController: HeaderProfileCollectionReusableViewDelegate {
    func updateFollwoBtn(user: UserModel) {
        for u in self.users {
            if u.uid == user.uid {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}

