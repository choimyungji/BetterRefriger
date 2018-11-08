//
//  SelectAreaButton.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 06/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

class SelectAreaButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)

    drawUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawUI() {
    backgroundColor = UIColor.colorFromRGB(0xCCCCCC)
    layer.masksToBounds = true
    layer.cornerRadius = frame.width/2

    setTitleColor(UIColor.black, for: .normal)
  }
}
