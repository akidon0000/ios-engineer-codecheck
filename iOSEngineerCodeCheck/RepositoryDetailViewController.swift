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
        
        let repo = searchVC.repositories[searchVC.index]
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        configure()
        
    }
    
    func configure(){
        
        let repo = searchVC.repositories[searchVC.index]
        
        titleLabel.text = repo["full_name"] as? String
        guard let owner = repo["owner"] as? [String: Any],
              let imgURL = owner["avatar_url"] as? String,
              let url = URL(string: imgURL) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
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
