//
//  FoodStatusLabel.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 22/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

enum FoodStatus {
  case normal, nearExpire, expired
}

@IBDesignable class FoodStatusLabel: UILabel {

  var type: FoodStatus = .normal {
    didSet {
      switch type {
      case .normal:
        isHidden = true
      case .nearExpire:
        isHidden = false
        backgroundColor = UIColor.BRColorOnWarning
        text = "마감임박"
      case .expired:
        isHidden = false
        backgroundColor = UIColor.BRColorOnError
        text = "유통기한지남"
      }
    }
  }
  @IBInspectable var topInset: CGFloat = 0.0
  @IBInspectable var bottomInset: CGFloat = 0.0
  @IBInspectable var leftInset: CGFloat = 3.0
  @IBInspectable var rightInset: CGFloat = 3.0

  override init(frame: CGRect) {
    super.init(frame: frame)
    drawUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawUI() {
    textColor = UIColor.white
    font = UIFont.systemFont(ofSize: 12)

    layer.masksToBounds = true
    layer.cornerRadius = 2

    sizeToFit()
  }

  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: topInset,
                                   left: rightInset,
                                   bottom: bottomInset,
                                   right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset,
                  height: size.height + topInset + bottomInset)
  }
}
