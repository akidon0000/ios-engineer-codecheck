//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import MarkdownView

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
    private let mdView = MarkdownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        initViewModel()
    }
    
    private func refresh() {
        let idx = searchViewModel.tappedCellIndex
        self.languageLabel.text = searchViewModel.repos[idx].lang
        self.starsLabel.text = searchViewModel.repos[idx].stars
        self.watchersLabel.text = searchViewModel.repos[idx].watchers
        self.forksLabel.text = searchViewModel.repos[idx].forks
        self.issuesLabel.text = searchViewModel.repos[idx].issues
        self.titleLabel.text = searchViewModel.repos[idx].title
        
        self.imageView.loadUrl(urlString: searchViewModel.repos[idx].imageUrl)
        self.viewModel.displayReadMe(ownerName: searchViewModel.repos[idx].ownerName, repoName: searchViewModel.repos[idx].repoName)
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
                    // self.activityIndicator.startAnimating()
                    break
                    
                case .ready: // 通信完了
                    // self.activityIndicator.stopAnimating()
                    // ReadMe書き込み
                    self.mdView.frame = self.view.bounds
                    self.mdView.load(markdown: self.viewModel.markdownReadMe)
//                     self.view.addSubview(self.mdView)
                    break
                    
                    
                case .error:
                    break
                    
                }//end switch
            }
        }
    }
}
