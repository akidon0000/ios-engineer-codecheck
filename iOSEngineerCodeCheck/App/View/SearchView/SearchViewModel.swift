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
    public let apiManager = ApiManager.singleton
    
    func searchText(_ text: String) {
        state?(.busy) // 通信開始（通信中）
        // API送信する
        self.apiManager.repository(text,
            success: { [weak self] (response) in
                guard let self = self else { // selfがnilになる可能性がある、通信が終わった際に呼ばれるが、存在するかわからない
                    fatalError()
                }
                self.repos.removeAll()
                for row in response.items {
                    let re = Repo()
                    if let lang = row.language {
                        re.lang = "Written in \(lang)"
                    } else {
                        re.lang = "Language None"
                    }
                    if let fullName = row.fullName {
                        re.title = fullName
                    } else {
                        re.title = "Title None"
                    }
                                        
                    re.stars = "\(row.stargazersCount ?? 0) stars"
                    re.watchers = "\(row.watchersCount ?? 0) watchers"
                    re.forks = "\(row.forksCount ?? 0) forks"
                    re.issues = "\(row.openIssuesCount ?? 0) open issues"
                    re.imageUrl = row.avatarImageUrl?.absoluteString ?? "NoImage"
                    self.repos.append(re)
                }
                self.state?(.ready) // 通信完了
            },
            
            failure: { [weak self] (error) in
            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
            // エラー中継（.stoppedを伝える必要があるため）
            //                    self?.state?(.error(.init(apiError: error)))
        }
        )
    }
}
