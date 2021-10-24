//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    public var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    private func refresh(){
        let idx = viewModel.tappedCellIndex
        self.languageLabel.text = viewModel.repos[idx].lang
        self.starsLabel.text = viewModel.repos[idx].stars
        self.watchersLabel.text = viewModel.repos[idx].watchers
        self.forksLabel.text = viewModel.repos[idx].forks
        self.issuesLabel.text = viewModel.repos[idx].issues
        self.titleLabel.text = viewModel.repos[idx].title
        let common = Common()
        self.imageView.image = common.getImageByUrl(urlString: viewModel.repos[idx].imageUrl)
    }
}
