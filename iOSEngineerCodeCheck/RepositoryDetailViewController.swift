//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var searchVC: SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let index = searchVC.index else {
            return
        }
        let detailRepo = searchVC.repositories[index]
        languageLabel.text = "Written in \(detailRepo["language"] as? String ?? "")"
        starsLabel.text = "\(detailRepo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(detailRepo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(detailRepo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(detailRepo["open_issues_count"] as? Int ?? 0) open issues"
        configure(detailRepo: detailRepo)
    }
    
    func configure(detailRepo: [String: Any]){
        titleLabel.text = detailRepo["full_name"] as? String
        guard let owner = detailRepo["owner"] as? [String: Any],
              let url = owner["avatar_url"] as? String,
              let imgUrl = URL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: imgUrl) { (data, res, err) in
            guard let data = data,
                  let img: UIImage = UIImage(data: data) else{
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }.resume()
    }
}
