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
        let name: String?         // リポジトリ名
        let fullName: String?     // オーナー名+リポジトリ名
        let language: String?     // リポジトリ言語
        let stargazersCount: Int? // スター数
        let watchersCount: Int?   // ウォッチ数
        let forksCount: Int?      // フォーク数
        let openIssuesCount: Int? // イシュー数
        let description: String?  // 説明文
        let homePage: String?     // ホームページ
        let pushedAt: String?     // 更新日
        let owner: Owner?         // オーナー情報
        let license: License?     // ライセンス情報
    }
    
    struct Owner: Decodable {
        let login: String?        // 名前
        let avatarUrl: String?    // アバター画像URL
    }
    
    struct License: Decodable {
        let key: String?          // キー
        let name: String?         // 名前
        let url: String?          // URL
    }
    
    func searchRepository(_ text: String,
                          success: @escaping (_ response: Repositories) -> (),
                          failure: @escaping (_ error: ApiError) -> ()) {
        
        guard let textEncodeString = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return failure(ApiError.invalidURL)
        }
        let url = "https://api.github.com/search/repositories?q=\(textEncodeString)"
        
        AKLog(level: .DEBUG, message: "[API] URL:\n\(url)")
        
        // タイムアウト設定
        manager.session.configuration.timeoutIntervalForRequest = API_TIMEOUT           // リクエスト開始まで
        manager.session.configuration.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
        
        manager.request(url,
                        method: .get,
                        encoding: URLEncoding(destination: .queryString),
                        headers: headers).responseJSON { response in
                            
                            AKLog(level: .DEBUG, message: "[API] HttpStatus:\(String(describing: response.response?.statusCode ?? 0))")
                            
                            switch (response.result) {
                            // 通信ステータス:OK
                            case .success:
                                
                                guard let jsonData = response.data else {
                                    AKLog(level: .ERROR, message: "[API] BadResponse")
                                    failure(ApiError.badResponse)
                                    return
                                }
                                // Json解析（共通レスポンス・ヘッダ処理）
                                do {
                                    let decoder = JSONDecoder()
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                    let res = try decoder.decode(Repositories.self, from: jsonData)
                                    //API成功
                                    success(res)
                                    
                                } catch (let error) {
                                    AKLog(level: .ERROR, message: "[API] JSONDecoder Error:\(error)")
                                    failure(ApiError.badResponse)
                                }
                                
                            // 通信ステータス:NG
                            case .failure(let error):
                                // 失敗
                                if error._code == NSURLErrorTimedOut {
                                    AKLog(level: .WARN, message: "[API] Timeout")
                                    failure(ApiError.timeout)
                                } else {
                                    switch response.response?.statusCode {
                                    // case 400:   // 要求不正
                                    // case 401:   // 認証不正
                                    case 404:   // URL不正
                                        AKLog(level: .ERROR, message: "[API] invalidURL: \(error)")
                                        failure(ApiError.invalidURL)
                                    // case 405:   // 許可されていないメソッド
                                    // case 409:   // 競合
                                    // case 500:   // サーバー内エラー
                                    // case 503:   // サービス利用不可
                                    default:
                                        AKLog(level: .ERROR, message: "[API] unknown: \(error)")
                                        failure(ApiError.unknown("unknown: \(error)"))
                                    }
                                }
                            }
                        }
    }
}
