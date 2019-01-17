//
//  MainViewTest.swift
//  BetterRefrigerTests
//
//  Created by Myungji Choi on 17/01/2019.
//  Copyright © 2019 maengji.com. All rights reserved.
//

import XCTest

class MainViewTest: XCTestCase {

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    let viewController = MainViewController()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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

  func test냉장실목록출력() {
    let foodsCount = 0
    XCTAssertGreaterThan(foodsCount, 0)
  }
}
