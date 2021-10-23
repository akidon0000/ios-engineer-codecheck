//
//  APIManager.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/23.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import Alamofire


extension ApiManager {
    
    struct Repositories: Decodable {
        let items: [Repository]
    }
    
    struct Repository: Decodable {
        let fullName: String
        let language: String?
        let description: String?
        let stargazersCount: Int
        let watchersCount: Int
        let forksCount: Int
        let openIssuesCount: Int
        let owner: Owner
        
        var avatarImageUrl: URL? {
            return URL(string: owner.avatarUrl)
        }
    }
    
    struct Owner: Decodable {
        let avatarUrl: String
    }
    
    func repository(_ text: String,
                    success: @escaping (_ response: Repositories) -> (),
                    failure: @escaping (_ error: ApiError) -> ()) {
        // APIリクエスト共通メソッド
        self.ApiCall(endPoint: text,
                     method: .get,
                     success:
                        { (res:Repositories) in
                            success(res)
                        },
                     failure:
                        failure)
    }
}
