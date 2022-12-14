//
//  SpaceType.swift
//  BetterRefriger
//
//  Created by 최명지 on 08/01/2019.
//  Copyright © 2019 maengji.com. All rights reserved.
//

import Foundation

var baseSpaces: [SpaceType] = [
    SpaceType(keyString: "refriger", name: "냉장"),
    SpaceType(keyString: "freezer", name: "냉동")]

struct SpaceType {
    var keyString: String
    var name: String?

    init(keyString: String = "refriger", name: String = "냉장") {
        self.keyString = keyString
        self.name = name
    }
}
