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
            if error != nil {
                XCTFail()
            }
        }
    }

    func testGetColor() {
        let colorChangeExpectation = expectation(description: "Expect the color change callback to get fired")
        func colorDidSetTest(color: UIColor) {
            colorChangeExpectation.fulfill()
        }
        let viewModel = ViewModel(colorDidSet: colorDidSetTest)
        viewModel.getColor()
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail()
            }
        }
    }

    func testSetColor() {
        let colorChangeExpectation = expectation(description: "Expect the color change callback to get fired")
        func colorDidSetTest(color: UIColor) {
            colorChangeExpectation.fulfill()
        }
        let viewModel = ViewModel(colorDidSet: colorDidSetTest)
        viewModel.setColor(UIColor.white)
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail()
            }
        }
    }

    func testRGBAInit() {
        do {
            let color = try UIColor(rgba_throws: "#C0FFEEFF")
            XCTAssertEqual(color.hexString(), "#C0FFEEFF")
        }
        catch {
            XCTFail()
        }
    }

    func testARGB2RGBA() {
        let unconverted: String = "#FFC0FFEE"
        guard let converted: String = unconverted.argb2rgba() else {
            XCTFail()
            return
        }
        XCTAssertEqual(converted, "#C0FFEEFF")

        let shortUnconverted: String = "#FC0F"
        guard let shortConverted: String = shortUnconverted.argb2rgba() else {
            XCTFail()
            return
        }
        XCTAssertEqual(shortConverted, "#C0FF")
    }
}
