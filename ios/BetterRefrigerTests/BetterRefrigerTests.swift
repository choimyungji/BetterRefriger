//
//  BetterRefrigerTests.swift
//  BetterRefrigerTests
//
//  Created by Myungji Choi on 26/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import XCTest
@testable import BetterRefriger

class BetterRefrigerTests: XCTestCase {

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_식품을_등록하면_푸시메시지를_새로_생성한다() {
    let notiManager = NotificationManager.getInstance
    let mainViewModel = MainViewModel(spaceType: SpaceType(keyString: "refriger"))

    let prevfood = FoodModel(name: "Egg",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
    mainViewModel.save(food: prevfood)
    var prevMessage: String?
    notiManager.message { message in
      prevMessage = message
    }

    let nextfood = FoodModel(name: "Milk",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
    mainViewModel.save(food: nextfood)

    var nextMessage: String?
    notiManager.message { message in
      nextMessage = message
    }

    XCTAssertEqual(prevMessage, nextMessage)
  }

  func test_식품을_삭제하면_푸시메시지를_새로_생성한다() {

  }
}
