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

struct MainViewModel {

  var spaceType: SpaceType?
  var foodService: FoodModelService
  var notiManager = NotificationManager.getInstance

  init(spaceType: SpaceType? = nil,
       service: FoodModelService = FoodModelService()) {
    self.spaceType = spaceType
    self.foodService = service
  }

  func foods(spaceType: SpaceType) -> [FoodModel] {
    var foods: [FoodModel] = []
    let data = foodService.data(spaceType: spaceType)
    data.forEach { object in
      foods.append(FoodModel(id: object.value(forKey: "seq") as? Int ?? 0,
                              name: object.value(forKey: "name") as? String ?? "",
                             registerDate: object.value(forKey: "registerDate") as? Date ?? Date(),
                             expireDate: object.value(forKey: "expireDate") as? Date ?? Date()))
    }

    return foods
  }

  func save(spaceType: SpaceType,
            food: FoodModel,
            completion: ((Int, Error?) -> Void)? = nil) {
    foodService.save(spaceType: spaceType, food: food) { (seq, error) in
      self.notiManager.foods = [food]
      self.notiManager.requestNotification { _, error in
        if error != nil {
          completion?(0, error)
        } else {
          completion?(seq, nil)
        }
      }
    }
  }

  func save(food: FoodModel,
            completion: ((Int) -> Void)? = nil) {
    guard let spaceType = spaceType else { return }
    foodService.save(spaceType: spaceType, food: food) { (seq, _) in
      self.notiManager.foods = [food]
      self.notiManager.requestNotification { (_, _) in
        completion?(seq)
      }
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
