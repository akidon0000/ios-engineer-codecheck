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
    
    static let reuseIdentifier = "SearchTableViewCell"
    
    /// セル高さ
    static let rowHeight: CGFloat = 150
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    static func nib() -> UINib {
        return UINib(nibName: SearchTableViewCell.reuseIdentifier, bundle: nil)
    }
    
}

// MARK: - Setting UI Method
extension SearchTableViewCell {
    private func initUI() {
        // 文字色の設定
        self.starLabel.textColor = .lightGray
        self.languageLabel.textColor = .lightGray
        self.lastUpdate.textColor = .lightGray
        // 言語アイコンの体裁設定
        self.languageIconView.backgroundColor = .gray
        self.languageIconView.clipsToBounds = true
        self.languageIconView.layer.cornerRadius = self.languageIconView.frame.width / 2
    }
    func setUI(repo: SearchViewModel.Repo) {
        self.userNameLabel.text = repo.title
        self.repoNameLabel.text = repo.title
        self.descriptionLabel.text = repo.title
        self.starLabel.text = repo.stars
        self.languageLabel.text = repo.lang
        self.lastUpdate.text = repo.title

    }
}
