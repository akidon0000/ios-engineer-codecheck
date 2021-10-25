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
        /// リポジトリ名
        let name: String?
        /// オーナー名+リポジトリ名
        let fullName: String?
        /// リポジトリ言語
        let language: String?
        /// スター数
        let stargazersCount: Int?
        /// ウォッチ数
        let watchersCount: Int?
        /// フォーク数
        let forksCount: Int?
        /// イシュー数
        let openIssuesCount: Int?
        /// 説明文
        let description: String?
        /// ホームページ
        let homePage: String?
        /// 更新日
        let pushedAt: String?
        /// オーナー情報
        let owner: Owner?
        ///　ライセンス情報
        let license: License?
    }
    
    struct Owner: Decodable {
        /// 名前
        let login: String?
        /// アバター画像URL
        let avatarUrl: String?
    }
    
    struct License: Decodable {
        /// キー
        let key: String?
        /// 名前
        let name: String?
        /// URL
        let url: String?
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
        let manager = Alamofire.SessionManager.default.session.configuration
        manager.timeoutIntervalForRequest = API_TIMEOUT // リクエスト開始まで
        manager.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        Alamofire.request(url,
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
    static private var jsonStrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
