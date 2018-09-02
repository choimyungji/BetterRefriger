//
//  UIColor+MJColor.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 1..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit

extension UIColor {
  class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}
