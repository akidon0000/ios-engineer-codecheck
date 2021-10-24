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

/// 言語カラー
enum LanguageIcon {
    case swift      // 薄いオレンジ色 #ffac45
    case cpp        // 濃いピンク色 #f34b7d
    case cn         // 灰色 #555555
    case cs         // 緑色 #178600
    case objectiveC // スカイブルー #438eff
    case javaSctipt // 黄色 #f1e05a
    case typeScript // 青緑色 #2b7489
    case css        // 紫色 #563d7c
    case html       // 薄い赤色 #e34c26
    case java       // 茶色 #b07219
    case kotlin     // 濃いオレンジ色 #F18E33
    case python     // 薄い青緑色 #3572A5
    case ruby       // 紅色 #701516
    case go         // #00ADD8
    case php        // #384d54
    case shell      // 薄い緑色 #89e051
    case other
    // swiftlint:disable cyclomatic_complexity
    init(language: String) {
        switch language {
        case "Swift":       self = .swift
        case "C++":         self = .cpp
        case "C":           self = .cn
        case "C#":          self = .cs
        case "Objective-C": self = .objectiveC
        case "JavaScript":  self = .javaSctipt
        case "TypeScript":  self = .typeScript
        case "CSS":         self = .css
        case "HTML":        self = .html
        case "Java":        self = .java
        case "Kotlin":      self = .kotlin
        case "Python":      self = .python
        case "Ruby":        self = .ruby
        case "Go":          self = .go
        case "PHP":         self = .php
        case "Shell":       self = .shell
        default:            self = .other
        }
    }
    // swiftlint:enable cyclomatic_complexity
    /// 言語毎のHEXカラー（色はGitHubのWebページ参考）
    var color: UIColor {
        switch self {
        case .swift:        return UIColor(hex: "ffac45")
        case .cpp:          return UIColor(hex: "f34b7d")
        case .cn:           return UIColor(hex: "555555")
        case .cs:           return UIColor(hex: "178600")
        case .objectiveC:   return UIColor(hex: "438eff")
        case .javaSctipt:   return UIColor(hex: "f1e05a")
        case .typeScript:   return UIColor(hex: "2b7489")
        case .css:          return UIColor(hex: "563d7c")
        case .html:         return UIColor(hex: "e34c26")
        case .java:         return UIColor(hex: "b07219")
        case .kotlin:       return UIColor(hex: "f18e33")
        case .python:       return UIColor(hex: "3572a5")
        case .ruby:         return UIColor(hex: "701516")
        case .go:           return UIColor(hex: "00add8")
        case .php:          return UIColor(hex: "384d54")
        case .shell:        return UIColor(hex: "89e051")
        case .other:        return UIColor(hex: "586069")
        }
    }
}


extension UIColor {
    /// HEX（16進数）で色を設定する
    /// - Parameters:
    ///   - hex: 色コード（例：#F18E33）
    ///   - alpha: 透明度（何も指定しないとデフォルトの1.0となる）
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let value = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(value / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(value / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(value / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
