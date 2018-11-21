//
//  UIToolbar+PickerOKButton.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 17..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit

extension UIToolbar {
  func toolbarPicker(mySelect: Selector) -> UIToolbar {
    let toolBar = UIToolbar()

    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor.black
    toolBar.sizeToFit()

    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain,
                                     target: self, action: mySelect)
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                      target: nil, action: nil)

    toolBar.setItems([ spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true

    return toolBar
  }
}

