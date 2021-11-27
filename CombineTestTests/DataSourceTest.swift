//
//  DataSourceTest.swift
//  CombineTestTests
//
//  Created by Gualtiero Frigerio on 27/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import Combine
import XCTest
@testable import CombineTest

class DataSourceTest: XCTestCase {
    let baseURLString = "https://jsonplaceholder.typicode.com"
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUsers() {
        let expectation = expectation(description: "testGetUsers")
        let dataSource = DataSource(baseURL: baseURLString)
        dataSource.getUsersWithMergedData().sink { mergedUsers in
            XCTAssertNotNil(mergedUsers)
            XCTAssertGreaterThan(mergedUsers.count, 0)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testGetUsersAsync() async {
        let dataSource = DataSourceAsync(baseURL: baseURLString)
        let users = await dataSource.getUsersWithMergedData()
        XCTAssertNotNil(users)
    }
    
    func testGetUsersNoExpectation() async {
        let dataSource = DataSource(baseURL: baseURLString)
        let users: [User]? = await withUnsafeContinuation { continuation in
            dataSource.getUsersWithMergedData().sink { users in
                continuation.resume(returning: users)
            }
            .store(in: &cancellables)
        }
        XCTAssertNotNil(users)
    }
}
