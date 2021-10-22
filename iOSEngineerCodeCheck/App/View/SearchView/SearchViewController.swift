//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var repositories: [Repository] = []
    var urlSessionTask: URLSessionTask?
    var tableCellDidSelectedIndex: Int? // nilの可能性あり
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell()
        let detailRepo = repositories[indexPath.row]
        tableCell.textLabel?.text = detailRepo.fullName
        tableCell.detailTextLabel?.text = detailRepo.language
        tableCell.tag = indexPath.row
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableCellDidSelectedIndex = indexPath.row
        let vc = R.storyboard.detailView.detailViewVC()!
        vc.searchVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension  SearchViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        GitHubAPI.taskCancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        GitHubAPI.searchRepository(text: searchBarText) { result in
            self.repositories = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}
