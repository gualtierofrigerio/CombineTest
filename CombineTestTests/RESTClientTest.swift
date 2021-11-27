//
//  RESTClientTest.swift
//  CombineTestTests
//
//  Created by Gualtiero Frigerio on 27/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import Combine
import XCTest
@testable import CombineTest

class RESTClientTest: XCTestCase {
    let testURLUsers = URL(string: "https://jsonplaceholder.typicode.com/users")!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
    }

    func testGetDataAsync() async {
        let data = await RESTClient.getData(atURL: testURLUsers)
        XCTAssertNotNil(data)
    }
    
    func testGetDataCompletion() {
        let expectation = expectation(description: "testGetDataCompletion")
        RESTClient.getDataCompletion(atURL: testURLUsers) { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testGetDataCompletionNoExpectation() async {
        let data: Data? = await withCheckedContinuation { continuation in
            RESTClient.getDataCompletion(atURL: testURLUsers) { data in
                continuation.resume(returning: data)
            }
        }
        
        XCTAssertNotNil(data)
    }
    
    func testGetDataFuture() throws {
        let expectation = expectation(description: "testGetDataFuture")
        let publisher = RESTClient.getData(atURL: testURLUsers)
            .catch { error in
                Just<Data>(Data())
            }
            .eraseToAnyPublisher()
        publisher.sink { data in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }

}
