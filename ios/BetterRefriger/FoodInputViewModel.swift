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
  init(initialData: FoodInputModel = FoodInputModel(), completion:
    ((FoodInputModel) -> ())? = nil) {
    var currentFood = initialData


  }
}
