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

  var tabName: String {
    switch refrigerType {
    case .freezer:
      return "냉동실"
    case .refriger:
      return "냉장실"
    }
  }
  var foods: [NSManagedObject] = []
  var refrigerType: RefrigerType

  init(refrigerType: RefrigerType,
       service: FoodModelService = FoodModelService()) {
    self.refrigerType = refrigerType
    foods = service.data(refrigerType: refrigerType.rawValue)
  }
}
