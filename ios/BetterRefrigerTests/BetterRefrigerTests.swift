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

  func test_식품을_등록하면_푸시메시지를_새로_생성한다1() {
    let notiManager = NotificationManager.shared
    let foodModelService = FoodModelService()
    //    let mainViewModel = MainViewModel(spaceType: SpaceType(keyString: "refriger"))

    let prevfood = FoodModel(name: "Chocolate",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)

    var expectation = expectation(description: "message")
    var expectedMessage: String = ""
    foodModelService.save(spaceType: SpaceType(keyString: "refriger", name: "냉장"),
                          food: prevfood) { seq, error in
      notiManager.message { message in

        expectedMessage = message
        expectation.fulfill()
      }
    }
//    Thread.sleep(forTimeInterval: 2)
//    sleep(2)
wait(for: [expectation], timeout: 2)
    XCTAssertEqual(expectedMessage, "Chocolate의 유통기한이 다 되어갑니다.")
  }

  func test_식품을_등록하면_푸시메시지를_새로_생성한다() {
    let notiManager = NotificationManager.shared
    let mainViewModel = MainViewModel(spaceType: SpaceType(keyString: "refriger"))

    let prevfood = FoodModel(name: "Egg",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)

    let nextfood = FoodModel(name: "Milk",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)

    var prevMessage: String?
    var nextMessage: String?

    mainViewModel.save(food: prevfood) { _ in
      notiManager.message { message in
        prevMessage = message

        mainViewModel.save(food: nextfood) { _ in
          notiManager.message { message in
            nextMessage = message
          }
        }
      }
    }

    sleep(5)
    XCTAssertEqual(prevMessage, "Egg의 유통기한이 다 되어갑니다.")
    XCTAssertEqual(nextMessage, "Milk의 유통기한이 다 되어갑니다.")
    print(prevMessage, nextMessage)

  }

  func test_식품을_추가하면_index를_반환한다() {

  }

  func test_식품은_현위치를_통해_삭제할수_있다() {

  }

  func test_식품을_삭제하면_푸시메시지를_새로_생성한다() {
    var prevMessage: String?
    var nextMessage: String?

    let notiManager = NotificationManager.shared
    let mainViewModel = MainViewModel(spaceType: SpaceType(keyString: "refriger"))

    let prevfood = FoodModel(name: "Egg",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
    mainViewModel.save(food: prevfood)
    notiManager.message { message in
        prevMessage = message
    }

    let nextfood = FoodModel(name: "Milk",
                             registerDate: Date(),
                             expireDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!)
    mainViewModel.save(food: nextfood) { seq in
      mainViewModel.remove(indexAt: seq)

      notiManager.message { message in
        nextMessage = message
      }
    }

    sleep(5)
    
    XCTAssertNotEqual(prevMessage, nextMessage)
  }
}
