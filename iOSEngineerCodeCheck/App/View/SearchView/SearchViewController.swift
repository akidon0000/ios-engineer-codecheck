//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var repositories: [[String: Any]]=[]
    var urlSessionTask: URLSessionTask?
    var tableCellDidSelectedIndex: Int? // nilの可能性あり
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlSessionTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text,
              let urlAfterSearchUrl = URL(string: "https://api.github.com/search/repositories?q=\(searchBarText)") else{
            return
        }
        
        urlSessionTask = URLSession.shared.dataTask(with: urlAfterSearchUrl) { (data, urlResponse, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data,
                  let objs = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let items = objs["items"] as? [[String: Any]] else {
                return
            }
            self.repositories = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        urlSessionTask?.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell()
        let detailRepo = repositories[indexPath.row]
        tableCell.textLabel?.text = detailRepo["full_name"] as? String ?? ""
        tableCell.detailTextLabel?.text = detailRepo["language"] as? String ?? ""
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
