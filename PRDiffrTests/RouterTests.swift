//
//  RouterTests.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import XCTest
import Alamofire
@testable import PRDiffr

class RouterTests: XCTestCase {
    let githubBaseURL = "https://api.github.com"
    let repo = "MagicalRecord"
    let repoOwner = "magicalpanda"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGetPullRequests() {
        let prUrl = "/repos/\(repoOwner)/\(repo)/pulls"
        let params: [String: Any] = [:]
        let router = Router.getPullRequests(params)

        XCTAssertEqual(router.method, HTTPMethod.get)
        XCTAssertEqual(router.path, prUrl)

        let url = URL(string: "\(githubBaseURL)\(prUrl)")
        XCTAssertEqual(router.urlRequest?.url!, url!)
    }
}
