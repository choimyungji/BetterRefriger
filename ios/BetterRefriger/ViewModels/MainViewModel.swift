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

//  var tabName: String {
//    switch refrigerType {
//    case .freezer:
//      return "냉동실"
//    case .refriger:
//      return "냉장실"
//    }
//  }
  var foods: [NSManagedObject] = []
  var refrigerType: RefrigerType
  var foodService: FoodModelService

  init(refrigerType: RefrigerType,
       service: FoodModelService = FoodModelService()) {
    self.refrigerType = refrigerType
    self.foodService = service
    foods = service.data(refrigerType: refrigerType)
  }

  func save(refrigerType: RefrigerType, name: String, registerDate: Date, expireDate: Date) {
    foodService.save(refrigerType: refrigerType,
                     name: name,
                     registerDate: registerDate,
                     expireDate: expireDate)
  }

  func remove(indexAt seq: Int) {
    foodService.remove(indexAt: seq)
  }
}
