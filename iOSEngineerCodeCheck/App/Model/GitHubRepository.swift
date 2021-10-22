//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/22.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import Alamofire

struct Repositories: Decodable {
    let items: [Repository]
}

struct Repository: Decodable {
    let fullName: String
    let language: String
    let description: String
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

class ApiManager{
    private static var task: URLSessionTask?
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
    
    static func taskCancel() {
        task?.cancel()
    }
    
    static private var jsonStrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
