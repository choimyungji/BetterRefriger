//
//  MainViewModelTests.swift
//  BetterRefrigerTests
//
//  Created by Myungji Choi on 07/04/2019.
//  Copyright © 2019 maengji.com. All rights reserved.
//

import XCTest
@testable import BetterRefriger

class MainViewModelTests: XCTestCase {
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_식품을_저장하면_dataObject_만들고_알림을_생성한다() {
    let mainViewModel = MainViewModel(spaceType: SpaceType(keyString: "refriger"))
    let food = FoodModel(name: "egg",
                         registerDate: Date(),
                         expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)

    mainViewModel.save(food: food)
  }
}
