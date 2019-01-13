//
//  FoodInputViewModel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 24/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import Foundation

protocol FoodInputViewModelType: ViewModelType {
}

struct FoodInputViewModel: FoodInputViewModelType {
  var spaceType: RefrigerType
  var seq: Int
  var foodName: String
  var registerDate: Date
  var expireDate: Date

  init(initialData: FoodInputModel = FoodInputModel(),
       completion: ((FoodInputModel) -> Void)? = nil) {
    var currentFood = initialData

    spaceType = initialData.refrigerType
    foodName = initialData.foodName
    registerDate = initialData.registerDate
    expireDate = initialData.expireDate
    seq = initialData.seq
  }
}
