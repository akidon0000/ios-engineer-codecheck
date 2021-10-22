//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    weak var searchVC: SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let index = searchVC.tableCellDidSelectedIndex else {
            return
        }
        let detailRepo = searchVC.repositories[index]
        languageLabel.text = "Written in \(detailRepo.language ?? "")"
        starsLabel.text = "\(detailRepo.stargazersCount) stars"
        watchersLabel.text = "\(detailRepo.watchersCount) watchers"
        forksLabel.text = "\(detailRepo.forksCount) forks"
        issuesLabel.text = "\(detailRepo.openIssuesCount) open issues"
        titleLabel.text = detailRepo.fullName
        imageView.image = getImageByUrl(url: detailRepo.avatarImageUrl)
    }
    
    func getImageByUrl(url: URL?) -> UIImage{
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}
