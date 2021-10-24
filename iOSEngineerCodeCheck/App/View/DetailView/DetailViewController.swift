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
    
    public var searchViewModel: SearchViewModel!
    var viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    private func refresh(){
        let idx = searchViewModel.tappedCellIndex
        self.languageLabel.text = searchViewModel.repos[idx].lang
        self.starsLabel.text = searchViewModel.repos[idx].stars
        self.watchersLabel.text = searchViewModel.repos[idx].watchers
        self.forksLabel.text = searchViewModel.repos[idx].forks
        self.issuesLabel.text = searchViewModel.repos[idx].issues
        self.titleLabel.text = searchViewModel.repos[idx].title
        let common = Common()
        self.imageView.image = common.getImageByUrl(urlString: searchViewModel.repos[idx].imageUrl)
    }
}
