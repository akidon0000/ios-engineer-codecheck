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
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent(fileName)
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        let urlString = ""
//        Alamofire.download("URL" + fileName, to: destination).response { response in
        AKLog(level: .DEBUG, message: "\(urlString)")
        Alamofire.request(urlString).response { response in
            guard let data = response.data else {
                failure(ApiError.none)
                return
            }
            success(data)
            return
            
//            if response.error == nil, let path = response.resumeData {//response.destinationURL?.path {
//                print("path::::\(path)")
//                success("ok")
//            } else {
//                failure(ApiError.none)
//            }
        }
        
    }
}
