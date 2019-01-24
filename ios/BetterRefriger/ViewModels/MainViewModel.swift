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

  var spaceType: SpaceType
  var foodService: FoodModelService

  init(spaceType: SpaceType,
       service: FoodModelService = FoodModelService()) {
    self.spaceType = spaceType
    self.foodService = service
  }

  func foods(spaceType: SpaceType) -> [NSManagedObject] {
    return foodService.data(spaceType: spaceType)
  }

  func save(spaceType: SpaceType, name: String, registerDate: Date, expireDate: Date) {
    foodService.save(spaceType: spaceType,
                     name: name,
                     registerDate: registerDate,
                     expireDate: expireDate)
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
