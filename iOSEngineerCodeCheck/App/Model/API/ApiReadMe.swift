//
//  ApiReadMe.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/24.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Alamofire


extension ApiManager {
    func download(urlString: String,
                  success: @escaping (_ response: Data) -> (),
                  failure: @escaping (_ error: ApiError) -> ()) {
        
        AKLog(level: .DEBUG, message: "\(urlString)")
        
        manager.session.configuration.timeoutIntervalForRequest = API_TIMEOUT // リクエスト開始まで
        manager.session.configuration.timeoutIntervalForResource = API_RESPONSE_TIMEOUT // リクエスト開始からレスポンス終了まで
        
        manager.request(urlString).response { response in
            guard let data = response.data else {
                failure(ApiError.none)
                return
            }
            success(data)
            return
        }
    }
}
