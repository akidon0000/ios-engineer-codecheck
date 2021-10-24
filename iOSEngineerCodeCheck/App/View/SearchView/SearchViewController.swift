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
    
    var viewModel = SearchViewModel()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        initViewModel()
        generateActivityIndicator()
        setupTableView()
    }
    
    private func setup() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.setUI(repo: self.viewModel.repos[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tappedCellIndex = indexPath.row
        let vc = R.storyboard.detailView.detailViewVC()!
        vc.viewModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension  SearchViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.searchText(text)
    }
    
    /// ViewModel初期化
    private func initViewModel() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else {
                fatalError()
            }
            DispatchQueue.main.async {
                switch state {
                case .busy: // 通信中
                    self.activityIndicator.startAnimating()
                    break

                case .ready: // 通信完了
                    self.activityIndicator.stopAnimating()
                    // View更新
                    self.tableView.reloadData()
                    break
                
                
                case .error:
                    break
                    
                }//end switch
            }
        }
    }
    
    private func generateActivityIndicator() {
        // ActivityIndicatorを作成＆中央に配置
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1)
        activityIndicator.hidesWhenStopped = true // クルクルをストップした時に非表示する
        self.view.addSubview(activityIndicator)
    }
}
