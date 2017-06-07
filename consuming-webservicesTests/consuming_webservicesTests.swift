//
//  consuming_webservicesTests.swift
//  consuming-webservicesTests
//
//  Created by Stephen Wong on 9/12/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import XCTest
@testable import consuming_webservices

class consuming_webservicesTests: XCTestCase {
    
    func testInit() {
        let colorChangeExpectation = expectation(description: "Expect the color change callback to get fired")
        func colorDidSetTest(color: UIColor) {
            colorChangeExpectation.fulfill()
        }
        let viewModel = ViewModel(colorDidSet: colorDidSetTest)
        viewModel.color = UIColor.white
        waitForExpectations(timeout: 5) { error in
            if let _ = error {
                XCTFail()
            }
        }
    }
}
