//
//  ReadMeViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/26.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import MarkdownView

class ReadMeViewController: BaseViewController {

    public var viewModel: DetailViewModel!
    @IBOutlet weak var readMeView: UIView!
    private let mdView = MarkdownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    @IBAction func buckButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func refresh() {
        self.mdView.frame = self.view.bounds
        self.mdView.load(markdown: self.viewModel.markdownReadMe)
        self.readMeView.addSubview(self.mdView)
    }
}
