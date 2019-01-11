//
//  SelectAreaButton.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 06/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit
import SnapKit

class SelectAreaButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)

    drawUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawUI() {
    snp.makeConstraints {
      $0.width.height.equalTo(54)
    }
    backgroundColor = UIColor(rgbHex: 0xCCCCCC)
    setTitleColor(UIColor.black, for: .normal)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    layer.masksToBounds = true
    layer.cornerRadius = frame.width/2
  }
}
