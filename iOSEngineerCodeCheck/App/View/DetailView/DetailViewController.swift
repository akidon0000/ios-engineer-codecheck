//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import MarkdownView

final class DetailViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    public var searchViewModel: SearchViewModel!
    var viewModel = DetailViewModel()
    private let mdView = MarkdownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    @IBAction func readMeButton(_ sender: Any) {
        let vc = R.storyboard.readMeView.readMeView()!
        vc.viewModel = self.viewModel
        self.present(vc, animated: true, completion: nil)
    }
    
    private func refresh() {
        let idx = searchViewModel.tappedCellIndex
        self.languageLabel.text = "Written in \(searchViewModel.repos[idx].lang)"
        self.starsLabel.text = searchViewModel.repos[idx].stars
        self.watchersLabel.text = searchViewModel.repos[idx].watchers
        self.forksLabel.text = searchViewModel.repos[idx].forks
        self.issuesLabel.text = searchViewModel.repos[idx].issues
        self.titleLabel.text = searchViewModel.repos[idx].title
        
        self.imageView.loadUrl(urlString: searchViewModel.repos[idx].imageUrl)
        self.viewModel.displayReadMe(ownerName: searchViewModel.repos[idx].ownerName, repoName: searchViewModel.repos[idx].repoName)
    }
    
}
