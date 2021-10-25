//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

/// サーバへリクエストを投げているか
/// 正しくサーバにパラメータを渡しているか
/// サーバとの通信が失敗した場合
/// サーバから返ってきたJSONデータが想定と異なる場合
/// サーバから返ってきたデータを正しく表示できているか

class iOSEngineerCodeCheckTests: XCTestCase {
    private let apiManager = ApiManager.singleton
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() {
        let exp = expectation(description: "Hoge")
        apiManager.searchRepository("Swift",
                                    success: { (response) in
                                        XCTAssertEqual(response.items[0].language!, "C++")
                                        exp.fulfill()
                                    },
                                    failure: {_ in })
        wait(for: [exp], timeout: 10.0)
    }
}
