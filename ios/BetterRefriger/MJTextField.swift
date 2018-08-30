//
//  MJTextField.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 8. 30..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit

class MJTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
