//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/22.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

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

class GitHubAPI{
    
    static func searchRepository(text: String, completionHandler: @escaping ([Repository]) -> Void) {
        if text.isEmpty { return }
            
        let urlString = "https://api.github.com/search/repositories?q=\(text)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
            session.finishTasksAndInvalidate()
            guard let date = data else {return}
            
            if let jsonData = try? jsonStrategyDecoder.decode(Repositories.self, from: date) {
                completionHandler(jsonData.items)
            }
        }
        task.resume()
    }
    
    static private var jsonStrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
