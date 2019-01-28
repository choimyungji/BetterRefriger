//
//  LabelButton.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 04/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit

@IBDesignable class LabelButton: UIButton {

  @IBInspectable var topInset: CGFloat = 0.0
  @IBInspectable var bottomInset: CGFloat = 0.0
  @IBInspectable var leftInset: CGFloat = 6.0
  @IBInspectable var rightInset: CGFloat = 6.0

  init(labelText: String) {
    super.init(frame: CGRect.zero)
    drawUI(labelText)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawUI(_ labelText: String) {
    backgroundColor = UIColor.BRColorOnActive
    let attrString = NSAttributedString(string: labelText,
                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                                     NSAttributedString.Key.foregroundColor: UIColor.BRColorBlack])
    setAttributedTitle(attrString, for: .normal)

    layer.masksToBounds = true
    layer.cornerRadius = 3

    sizeToFit()
  }

  override func draw(_ rect: CGRect) {
    let insets = UIEdgeInsets.init(top: topInset,
                                   left: rightInset,
                                   bottom: bottomInset,
                                   right: rightInset)
    super.draw(rect.inset(by: insets))

  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset,
                  height: size.height + topInset + bottomInset)
  }
}
