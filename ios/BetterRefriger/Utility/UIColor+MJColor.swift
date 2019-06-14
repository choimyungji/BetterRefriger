//
//  UIColor+MJColor.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 1..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit

extension UIColor {

  @available(*, deprecated, message: "Use UIColor.init(_ rgbValue: UInt)")
  class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  convenience init(rgbHex: UInt) {
    self.init(red: CGFloat((rgbHex & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbHex & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbHex & 0x0000FF) / 255.0,
              alpha: 1.0)
  }

  static var BRColorOnWarning = UIColor.orange
  static var BRColorOnError = UIColor(rgbHex: 0xd0021b)
  static var BRColorOnActive = UIColor(rgbHex: 0x3333ff)
  static var BRColorBlack = UIColor(rgbHex: 0x1d2129)
}
