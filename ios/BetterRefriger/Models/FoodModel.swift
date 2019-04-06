//
//  FoodModel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 25/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

class FoodModel: NSObject {

  convenience init(name: String, registerDate: Date, expireDate: Date) {
    self.init()

    self.foodName = name
    self.registerDate = registerDate
    self.expireDate = expireDate
  }

  var seq = Int()
  var foodName = String()
  var registerDate = Date()
  var expireDate = Date()
}
