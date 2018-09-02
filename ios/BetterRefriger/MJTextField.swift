//
//  MJTextField.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 8. 30..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit
import SnapKit

class MJTextField: UITextField {
  override func draw(_ rect: CGRect) {
    layer.borderWidth = 0.333
    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 8

    self.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 16))
    self.leftViewMode = .always
  }
}
