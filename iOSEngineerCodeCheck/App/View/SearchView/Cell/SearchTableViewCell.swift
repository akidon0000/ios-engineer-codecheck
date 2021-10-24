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
    @IBOutlet weak var contributorsLabel: UILabel!
    
    static let reuseIdentifier = "SearchTableViewCell"
    
    /// セル高さ
    static let rowHeight: CGFloat = 150
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.initUI()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    static func nib() -> UINib {
        return UINib(nibName: SearchTableViewCell.reuseIdentifier, bundle: nil)
    }

//    func bind(title: String, detail: String) {
//        self.userNameLabel.text = title
//        self.repoNameLabel.text = detail
//    }
    
}

// MARK: - Setting UI Method
extension SearchTableViewCell {
    private func initUI() {
        // 文字色の設定
        self.starLabel.textColor = .lightGray
        self.languageLabel.textColor = .lightGray
        self.contributorsLabel.textColor = .lightGray
        // スター色の設定
//        self.starImageView.tintColor = .gray
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
        self.contributorsLabel.text = repo.title
//        self.setLanguageIconColor(language: repo.lang)

    }
//    private func setLanguageIconColor(language: String?) {
//        guard let language = language else { return }
//        self.languageIconView.backgroundColor = LanguageIcon(language: language).color
//    }
}
