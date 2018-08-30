//
//  FoodInputViewController.swift
//  BetterRefriger
//
//  Created by Myungji on 2017. 9. 22..
//  Copyright © 2017년 maengji.com. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class FoodInputViewController : UIViewController {
  var txtFoodName = MJTextField()
  var txtRegisterDate = MJTextField()
  var txtExpireDate = MJTextField()
  
  func touchInputComplete(_ sender: UIButton) {
  }
  
  override func viewDidLoad() {
    drawUI()
  }
  
  func drawUI() {
    view.backgroundColor = .white
    
    let lblName = UILabel()
    view.addSubview(lblName)
    lblName.text = "이름"
    lblName.snp.makeConstraints { m in
      m.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
      m.left.equalToSuperview().offset(16)
      m.right.equalToSuperview().offset(-16)
    }
    lblName.font = UIFont.systemFont(ofSize: 17)
    
    view.addSubview(txtFoodName)
    txtFoodName.snp.makeConstraints { m in
      m.top.equalTo(lblName.snp.bottom).offset(8)
      m.left.equalToSuperview().offset(16)
      m.right.equalToSuperview().offset(-16)
      m.height.equalTo(48)
    }
    
    let lblRegister = UILabel()
    view.addSubview(lblRegister)
    lblRegister.text = "등록일"
    lblRegister.snp.makeConstraints { m in
      m.top.equalTo(txtFoodName.snp.bottom).offset(10)
      m.left.equalToSuperview().offset(16)
      m.right.equalToSuperview().offset(-16)
    }
    lblRegister.font = UIFont.systemFont(ofSize: 17)
    
    view.addSubview(txtRegisterDate)
    txtRegisterDate.snp.makeConstraints { m in
      m.top.equalTo(lblRegister.snp.bottom).offset(8)
      m.left.equalToSuperview().offset(16)
      m.right.equalToSuperview().offset(-16)
      m.height.equalTo(48)
    }
    
    let lblExpire = UILabel()
    view.addSubview(lblExpire)
    lblExpire.text = "유통기한"
    lblExpire.snp.makeConstraints { m in
      m.top.equalTo(txtRegisterDate.snp.bottom).offset(10)
      m.left.equalToSuperview().offset(16)
      m.right.equalToSuperview().offset(-16)
    }
    lblName.font = UIFont.systemFont(ofSize: 17)
    
    view.addSubview(txtExpireDate)
    txtExpireDate.snp.makeConstraints { m in
      m.top.equalTo(lblExpire.snp.bottom).offset(8)
      m.left.equalToSuperview().offset(16)
      m.right.equalToSuperview().offset(-16)
      m.height.equalTo(48)
    }
  }
}
