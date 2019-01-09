//
//  UIView+Subviews.swift
//  BetterRefriger
//
//  Created by 최명지 on 21/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    for view in views {
      addSubview(view)
    }
  }
}
