//
//  FoodModel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 25/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

struct FoodModel: Hashable, Identifiable {
    var id: Int

    var name: String
    var registerDate: Date
    var expireDate: Date
}
