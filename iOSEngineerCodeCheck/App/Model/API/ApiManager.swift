//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/22.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import Network
import Alamofire

/// 通信タイムアウト時間　（方式設計指定値  リクエスト:30s　レスポンス:60s）
let API_TIMEOUT: TimeInterval = 10.0
let API_RESPONSE_TIMEOUT: TimeInterval = 10.0
/// HTTPステータス有効(成功)範囲
let API_HTTP_VALIDATE_STATUS = 200..<201

/// APIエラー
public enum ApiError: Error {
    case none               // なし（正常）
    case notAvailable       // 通信不可
    case timeout            // タイムアウト
    case badRequest         // 要求不正
    case invalidAuth        // 認証不正
    case invalidURL         // URL不正
    case badResponse        // 応答不正
    case tokenFailure       // トークン認証エラー
    case stopped            // サービス停止中（メンテナンス中画面を表示して中断）
    case unknown(String)    // 未知
    case alert(String)      // アラート表示
}

//MARK: - リクエスト・ベースクラス

protocol ApiRequest: Codable {
    /// JSON-Dictionaryを返却
    ///
    /// - Returns: JSON-Dictionary
    func toDict() -> [String: Any]?
    
    /// JSON-Dataを返却
    ///
    /// - Returns: JSON-Data
    func toData() -> Data?
}

extension ApiRequest {
    /// JSON-Dictionaryを返却
    ///
    /// - Returns: JSON-Dictionary
    func toDict() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: toData()!, options: .allowFragments) as? [String: Any]
        } catch (let error) {
            AKLog(level: .ERROR, message: "[API] JSONSerialization Error:\(error)")
            return nil
        }
    }
    
    /// JSON-Dataを返却
    ///
    /// - Returns: JSON-Data
    func toData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch (let error) {
            AKLog(level: .ERROR, message: "[API] JSONEncoder Error:\(error)")
            return nil
        }
    }
}

class ApiManager: NSObject {
    
    
    // MARK: - Public value
    static let singleton = ApiManager() // シングルトン・インタンス

    // ネットワーク接続状態
    private var isConnected = false
    
    /// シングルトン・インスタンスの初期処理
    private override init() {  //シングルトン保証// privateにすることにより他から初期化させない
        super.init()

        // ネットワーク接続状態のモニタリング
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                // Connect
                self?.isConnected = true
            }else{
                // Disconnect
                self?.isConnected = false
            }
        }
        let queue = DispatchQueue(label: "com.akidon0000.queue")
        monitor.start(queue: queue)
    }

    // MARK: - Public API FUNCTION
    
    /// リクエスト共通メソッド
    ///
    /// - Parameters:
    ///   - endPoint: APIエンドポイント
    ///   - method: HTTPMethod
    ///   - reqeust: BaseRequest
    ///   - success: 正常時実行
    ///   - failure: 異常時実行
    func ApiCall<ResponseT:Decodable>(
        endPoint: String,
        method: HTTPMethod,
        reqeust: ApiRequest,
        success: @escaping (_ response:ResponseT) -> (),
        failure: @escaping (_ error:ApiError) -> ())
    {
        // 接続確認
        if self.isConnected == false {
            AKLog(level: .WARN, message: "[API] 通信不可")
            failure(ApiError.notAvailable)
            return
        }

        // リクエストJsonを作成
        guard reqeust.toData() != nil, let reqeustDict = reqeust.toDict() else {
            AKLog(level: .ERROR, message: "[API] BadRequest")
            failure(ApiError.badRequest)
            return
        }
        
        let url = "https://api.github.com/search/repositories?q=" + endPoint
        AKLog(level: .DEBUG, message: "[API] URL:\n\(url)")
        AKLog(level: .DEBUG, message: "[API] Request:\n\(reqeustDict)")

        // タイムアウト設定
        let manager = Alamofire.SessionManager.default.session.configuration
        manager.timeoutIntervalForRequest = API_TIMEOUT // リクエスト開始まで
        manager.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
        
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let request = Alamofire.request(url,
                          method: method,
                          parameters: reqeustDict,
                          encoding: JSONEncoding(), //URLEncoding(destination: .queryString),
                          headers: headers).validate(statusCode: API_HTTP_VALIDATE_STATUS)
        
        request.responseData(completionHandler: { (response) in
            AKLog(level: .DEBUG, message: "[API] HttpStatus:\(String(describing: response.response?.statusCode ?? 0))")
            switch (response.result) {
            // 通信ステータス:OK
            case .success:
                guard let jsonData = response.data else {
                    AKLog(level: .ERROR, message: "[API] BadResponse")
                    failure(ApiError.badResponse)
                    return
                }
                #if DEBUG
                    // Json文字列を出力
                    let jsonString = String(data: jsonData, encoding: .utf8) ?? response.debugDescription
                    AKLog(level: .DEBUG, message: "[API] Response:\n\(jsonString)")
                #endif
                // Json解析（共通レスポンス・ヘッダ処理）
                do {
                    let res = try JSONDecoder().decode(ResponseT.self, from: jsonData)
                    AKLog(level: .DEBUG, message: "[API] res:\(res)    \(ResponseT.self)")
                    //API成功
                    success(res)
                }
                catch (let error) {
                    AKLog(level: .DEBUG, message: "[API] JSONDecoder Error:\(error)")
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
                    case 400:   // 要求不正
                        AKLog(level: .ERROR, message: "[API] badRequest: \(error)")
                        failure(ApiError.badRequest)
                    case 401:   // 認証不正
                        AKLog(level: .ERROR, message: "[API] invalidAuth: \(error)")
                        failure(ApiError.invalidAuth)
                    case 404:   // URL不正
                        AKLog(level: .ERROR, message: "[API] invalidURL: \(error)")
                        failure(ApiError.invalidURL)
                    default:
                        AKLog(level: .ERROR, message: "[API] unknown: \(error)")
                        failure(ApiError.unknown("unknown: \(error)"))
                    }
                }
            }
        })
    }
}
