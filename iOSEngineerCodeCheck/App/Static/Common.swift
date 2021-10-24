//
//  Common.swift
//  iOSEngineerCodeCheck
//
//  Created by Akihiro Matsuyama on 2021/10/24.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class Common: UIView {
    func getImageByUrl(urlString: String) -> UIImage{
        guard let url = URL(string: urlString) else {
            AKLog(level: .WARN, message: "NoImage")
            return UIImage()
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)!
        } catch let err {
            AKLog(level: .WARN, message: "NoImage: \(err)")
            return UIImage()
        }
    }

}
