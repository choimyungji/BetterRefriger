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

  init(initialData: FoodModel = FoodModel(),
       completion: ((FoodModel) -> Void)? = nil) {
    var currentFood = initialData

    spaceType = initialData.spaceType
    foodName = initialData.foodName
    registerDate = initialData.registerDate
    expireDate = initialData.expireDate
    seq = initialData.seq
  }
}
