//
//  SearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/22.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

final class SearchViewModel: NSObject {
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    
    struct Repo {
        var lang = ""
        var stars = ""
        var watchers = ""
        var forks = ""
        var issues = ""
        var title = ""
        var imageUrl = ""
        var ownerName = ""
        var repoName = ""
        var desc = ""
        var lastUpdate = ""
    }
    
    var repos:[Repo] = []
    var tappedCellIndex = 0
    let apiManager = ApiManager.singleton
    
    func searchText(_ text: String) {
        state?(.busy) // 通信開始（通信中）
        
        // API送信する
        self.apiManager.searchRepository(text,
                                         success: { [weak self] (response) in
                                            guard let self = self else { // SearchViewModelのself
                                                AKLog(level: .FATAL, message: "[self] FatalError")
                                                fatalError()
                                            }
                                            
                                            self.repos.removeAll()
                                            
                                            for row in response.items {
                                                var re = Repo()
                                                if let lang = row.language {
                                                    re.lang = lang 
                                                } else {
                                                    re.lang = "None"
                                                }
                                                if let fullName = row.fullName {
                                                    re.title = fullName
                                                } else {
                                                    re.title = "Title None"
                                                }
                                                if let desc = row.description {
                                                    if desc.count < 100 { // 説明文が100文字超えていたら省略
                                                        re.desc = desc
                                                        
                                                    } else {
                                                        re.desc = "\(desc.prefix(100))..."
                                                    }
                                                    
                                                } else {
                                                    re.desc = "None"
                                                }
                                                
                                                re.stars = "\(row.stargazersCount ?? 0) stars"
                                                re.watchers = "\(row.watchersCount ?? 0) watchers"
                                                re.forks = "\(row.forksCount ?? 0) forks"
                                                re.issues = "\(row.openIssuesCount ?? 0) open issues"
                                                re.imageUrl = row.owner?.avatarUrl ?? "NoImage"
                                                re.ownerName = row.owner?.login ?? "None"
                                                re.repoName = row.name ?? "None"
                                                
                                                re.lastUpdate = self.timeLag(row.pushedAt)
                                                
                                                self.repos.append(re)
                                            }
                                            self.state?(.ready) // 通信完了
                                         },
                                         
                                         failure: { [weak self] (error) in
                                            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
                                            self?.state?(.error) // エラー表示
                                         }
        )
    }
    
    private func timeLag(_ updatedAt: String?) -> String {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        
        guard let updated = updatedAt,
              let date = formatter.date(from: updated) else {
            return "None"
        }
        
        let text = "Updated " + timeSpanText(timeSpan: now.timeIntervalSince(date))
        return text
    }
    
    private func timeSpanText(timeSpan: TimeInterval) -> String {
        let span = Int(timeSpan) // 秒
        
        let seconds = 0
        let minutes = 60
        let hours = minutes * 60
        let days = hours * 24
        let years = days * 365
        
        switch span {
        case seconds ..< hours: // 0秒〜60分
            let text = String(span / minutes)
            return "\(text) minutes ago"
            
            
        case hours ..< days: // 1時間〜24時間
            let text = String(span / hours)
            return "\(text) hours ago"
            
            
        case days ..< years: // 1日〜365日
            let text = String(span / days)
            return "\(text) days ago"
            
            
        default: // 1年〜
            let text = String(span / years)
            return "\(text) years ago"
        }
    }
    
}
