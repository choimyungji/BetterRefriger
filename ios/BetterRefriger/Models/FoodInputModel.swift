//
//  FoodInputModel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 25/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

//enum RefrigerType: Int {
//  case refriger, freezer
//}

class FoodInputModel: NSObject {
  var refrigerType = RefrigerType()
  var seq = Int()
  var foodName = String()
  var registerDate = Date()
  var expireDate = Date()

//  override init() {
//    super.init()
//    print("nothing")
//  }
}
