//
//  PicturesLoaderTest.swift
//  CombineTestTests
//
//  Created by Gualtiero Frigerio on 27/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import XCTest
@testable import CombineTest

class PicturesLoaderTest: XCTestCase {
    let pictureToTest = PictureWithImage(title: "title",
                                         imageUrl: "https://via.placeholder.com/600/92c952",
                                         image: nil)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPicturesStream() async {
        let picturesTestArray = [pictureToTest]
        let picturesLoader = PicturesLoader(withPictures: picturesTestArray)
        var loaded = 0
        for await picture in picturesLoader.getPicturesStream() {
            XCTAssertNotNil(picture.image)
            loaded += 1
        }
        XCTAssertEqual(loaded, picturesTestArray.count)
    }

}
