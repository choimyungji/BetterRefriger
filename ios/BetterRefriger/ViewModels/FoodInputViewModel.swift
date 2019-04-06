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
  var spaceType: SpaceType
  var seq: Int
  var foodName: String
  var registerDate: Date
  var expireDate: Date

  init(food: FoodModel = FoodModel(),
       spaceType: SpaceType,
       completion: ((FoodModel) -> Void)? = nil) {
    var currentFood = food

    self.spaceType = spaceType
    foodName = food.foodName
    registerDate = food.registerDate
    expireDate = food.expireDate
    seq = food.seq
  }
}
