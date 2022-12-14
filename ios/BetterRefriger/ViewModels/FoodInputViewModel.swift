//
//  FoodInputViewModel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 24/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import Foundation

protocol FoodInputViewModelType {
}

struct FoodInputViewModel: FoodInputViewModelType {
    var spaceType: SpaceType
    var food: FoodModel
    let foodService = FoodModelService()

    init(food: FoodModel? = nil,
         spaceType: SpaceType) {
        self.spaceType = spaceType
        self.food = food ?? FoodModel(id: nil, name: "", registerDate: Date(), expireDate: Date())
    }

    func add(food: FoodModel) {
        foodService.save(spaceType: spaceType, food: food)
    }
}
