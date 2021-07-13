//
//  Color+extension.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2021/07/13.
//  Copyright © 2021 maengji.com. All rights reserved.
//

import SwiftUI

extension Color {
    init(rgbHex: UInt) {
        self.init(red: Double((rgbHex & 0xFF0000) >> 16) / 255.0,
                  green: Double((rgbHex & 0x00FF00) >> 8) / 255.0,
                  blue: Double(rgbHex & 0x0000FF) / 255.0)
    }
}
