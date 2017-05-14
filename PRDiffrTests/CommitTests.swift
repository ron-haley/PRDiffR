//
//  CommitTests.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import XCTest
@testable import PRDiffr

class CommitTests: XCTestCase {
    let response = HTTPURLResponse()
    var testBundle: Bundle!
    var filePath: String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBundle = Bundle(for: type(of: self))
        filePath = testBundle.path(forResource: "commit", ofType: "json")
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

    func testInit() {
        let json = Helper.readJSON(fileName: filePath!) as [[String: Any]]
        let commit = Commit(response: response, representation: json.first!)
        
        // Only testing a few attrs that I may use in app
        XCTAssertNotNil(commit?.email)
        XCTAssertNotNil(commit?.message)
        XCTAssertNotNil(commit?.name)
    }
    
    func testCollection() {
        let json = Helper.readJSON(fileName: filePath!) as [[String: Any]]
        let commits = Commit.collection(from: response, withRepresentation: json)
        
        XCTAssertTrue(commits.count == 1)
    }
}
