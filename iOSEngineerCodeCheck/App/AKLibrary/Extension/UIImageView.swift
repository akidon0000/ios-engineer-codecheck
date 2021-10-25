//
//  UI.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/25.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 画像をURLより読み込んで表示する(**非同期にするべき**)
    func loadUrl(urlString: String) {
        self.image = nil
        guard let url = URL(string: urlString) else {
            AKLog(level: .WARN, message: "NoImage")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            self.image = UIImage(data: data)
        } catch let err {
            AKLog(level: .WARN, message: "NoImage: \(err)")
            return
        }
    }
    
}
