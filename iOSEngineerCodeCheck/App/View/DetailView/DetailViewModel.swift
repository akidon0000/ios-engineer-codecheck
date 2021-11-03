//
//  DetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/24.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class DetailViewModel: NSObject {
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    let apiManager = ApiManager.singleton
    var markdownReadMe = ""
    
    func displayReadMe(ownerName: String,
                       repoName: String) {
        
        let urlString = "https://raw.githubusercontent.com/\(ownerName)/\(repoName)/main/README.md"
        self.apiManager.download(urlString: urlString,
                                 success: { [weak self] (response) in
                                    guard let self = self else { // SearchViewModelのself
                                        AKLog(level: .FATAL, message: "[self] FatalError")
                                        fatalError()
                                    }
                                    if let markdown = String(data: response, encoding: .utf8) {
                                        self.markdownReadMe = markdown
                                    }
                                    
                                 },
                                 
                                 failure: { [weak self] (error) in
                                    AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
                                 })
    }
}
