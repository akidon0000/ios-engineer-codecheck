//
//  SearchTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/23.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageIconView: UIView!
    @IBOutlet weak var lastUpdate: UILabel!
    
    /// セル高さ
    static let rowHeight: CGFloat = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    
}

// MARK: - Setting UI Method
extension SearchTableViewCell {
    private func initUI() {
        // 言語アイコンの体裁設定
        self.languageIconView.backgroundColor = .gray
        self.languageIconView.clipsToBounds = true
        self.languageIconView.layer.cornerRadius = self.languageIconView.frame.width / 2
    }
    
    func setUI(repo: SearchViewModel.Repo) {
        self.imgView.loadUrl(urlString: repo.imageUrl)
        self.userNameLabel.text = repo.ownerName
        self.repoNameLabel.text = repo.repoName
        self.descriptionLabel.text = repo.desc
        self.starLabel.text = repo.stars
        self.languageLabel.text = repo.lang
        setLanguageIconColor(language: repo.lang)
        self.lastUpdate.text = repo.lastUpdate
    }
    
    private func setLanguageIconColor(language: String?) {
        guard let language = language else { return }
        switch language {
        case "Swift":
            self.languageIconView.backgroundColor = UIColor.red
        case "Python":
            self.languageIconView.backgroundColor = UIColor.blue
        default:
            self.languageIconView.backgroundColor = UIColor.gray
        }
    }
}
