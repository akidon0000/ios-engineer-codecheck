//
//  SearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/22.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class SearchViewModel: NSObject {
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    
    final class Repo {
        var lang = ""
        var stars = ""
        var watchers = ""
        var forks = ""
        var issues = ""
        var title = ""
        var imageUrl = ""
    }

    var repos:[Repo] = []
    var tappedCellIndex = 0
    
    func searchText(_ text: String) {
        state?(.busy)
        // 静的なメソッド　頻繁に使用する為
        ApiManager.searchRepository(text: text) { [weak self] result in
            // 別スレッド
            guard let self = self else { // selfがnilになる可能性がある、通信が終わった際に呼ばれるが、存在するかわからない
                fatalError()
            }
            
            for row in result {
                let re = Repo()
                re.lang = "Written in \(row.language)"
                re.stars = "\(row.stargazersCount) stars"
                re.watchers = "\(row.watchersCount) watchers"
                re.forks = "\(row.forksCount) forks"
                re.issues = "\(row.openIssuesCount) open issues"
                re.title = row.fullName
                re.imageUrl = row.avatarImageUrl?.absoluteString ?? ""
                self.repos.append(re)
            }
            self.state?(.ready)
        }
    }
}
