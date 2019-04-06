//
//  BetterRefrigerTests.swift
//  BetterRefrigerTests
//
//  Created by Myungji Choi on 26/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import XCTest

class BetterRefrigerTests: XCTestCase {

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_식품을_등록하면_푸시메시지를_새로_생성한다() {
    let pushManager = PushManager.getInstance()
    let prevPushMessage = pushManager.message("main")
    let food = FoodModel(type: "refriger",
                         name: "egg",
                         regDate: Date.now,
                         expireDate: Date.now + 3)

    let space = SpaceManager()
    space.add(food)

    let nextPushMessage = pushManager.message("main")

    XCTAssertEqual(prevPushMessage, nextPushMessage)
  }

  func test_식품을_삭제하면_푸시메시지를_새로_생성한다() {

  }
}
