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
        self.ApiCall(endPoint: "user",
                     method: .post,
                     reqeust: text as! ApiRequest,
                     success:
                        { (res:Repositories) in
                            success(res)
                        },
                     failure:
                        failure)
    }
    
    
    // 静的メソッド
    static func searchRepository(text: String, completionHandler: @escaping ([Repository]) -> Void) {
        if text.isEmpty { return }
        
        let urlString = "https://api.github.com/search/repositories?q=\(text)"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(urlString,
                          method: .get,
                          encoding: URLEncoding(destination: .queryString),
                          headers: headers).responseJSON { response in
                            
                            guard let data = response.data else { return }
                            do {
                                let jsonData = try jsonStrategyDecoder.decode(Repositories.self, from: data)
                                completionHandler(jsonData.items) // このデータを無くさない為に@escaping リークの可能性あり
                            } catch { // パースエラー
                                print(error)
                                print(error.localizedDescription)
                            }
                          }
    }
    static private var jsonStrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
