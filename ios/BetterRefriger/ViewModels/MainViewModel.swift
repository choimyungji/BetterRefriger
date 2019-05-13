//
//  MainViewModel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 22/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import CoreData
import RxSwift
import RxCocoa

protocol MainViewModelType: ViewModelType {
//  var didTapRightBarButton: PublishSubject<Void> { get }
//  var editSetting: Driver<FoodInputViewModelType> { get }
}

struct MainViewModel: MainViewModelType {
//  let didTapRightBarButton = PublishSubject<Void>()
//  let editSetting: Driver<FoodInputViewModelType>

  var spaceType: SpaceType?
  var foodService: FoodModelService
  var notiManager = NotificationManager.getInstance

  init(spaceType: SpaceType? = nil,
       service: FoodModelService = FoodModelService()) {
    self.spaceType = spaceType
    self.foodService = service
  }

  func foods(spaceType: SpaceType) -> [NSManagedObject] {
    return foodService.data(spaceType: spaceType)
  }

  func save(spaceType: SpaceType,
            food: FoodModel,
            completion: ((Int, Error?) -> Void)? = nil) {
    let seq = foodService.save(spaceType: spaceType, food: food)
    notiManager.foods = [food]
    notiManager.requestNotification { _, error in
      if error != nil {
        completion?(0, error)
      } else {
        completion?(seq, nil)
      }
    }
  }

  func save(food: FoodModel,
            completion: ((Int) -> Void)? = nil) {
    guard let spaceType = spaceType else { return }
    let seq = foodService.save(spaceType: spaceType, food: food)
    notiManager.foods = [food]
    notiManager.requestNotification { (_, _) in
      completion?(seq)
    }
  }

  func update(spaceType: SpaceType, seq: Int, name: String, registerDate: Date, expireDate: Date) {
    foodService.update(spaceType: spaceType,
                       seq: seq,
                       name: name,
                       registerDate: registerDate,
                       expireDate: expireDate)
  }

  func remove(indexAt seq: Int) {
    foodService.remove(indexAt: seq)
  }
}
