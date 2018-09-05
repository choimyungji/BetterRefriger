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

class FoodInputViewController: UIViewController {
  var scrollView = UIScrollView()
  var contentsView = UIView()
  var txtFoodName = MJTextField()
  var txtRegisterDate = MJTextField()
  var txtExpireDate = MJTextField()
  var btnRegister = UIButton()

  func touchInputComplete(_ sender: UIButton) {
  }

  override func viewDidLoad() {
    drawUI()
  }

  override func viewDidLayoutSubviews() {

  }

  func drawUI() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { maker in
      maker.edges.equalToSuperview()
    }

    scrollView.addSubview(contentsView)
    contentsView.snp.makeConstraints { maker in
      maker.edges.equalToSuperview()
      maker.width.equalToSuperview()
      maker.height.greaterThanOrEqualToSuperview()
    }

    view.addSubview(btnRegister)

    let lblName = UILabel()
    let lblRegister = UILabel()
    let lblExpire = UILabel()
    [lblName, txtFoodName, lblRegister, txtRegisterDate, lblExpire, txtExpireDate]
      .forEach {
        contentsView.addSubview($0)
    }

    lblName.text = "이름"
    lblName.snp.makeConstraints { maker in
      maker.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
      maker.left.equalToSuperview().offset(16)
      maker.right.equalToSuperview().offset(-16)
    }
    lblName.font = UIFont.systemFont(ofSize: 17)

    txtFoodName.snp.makeConstraints { maker in
      maker.top.equalTo(lblName.snp.bottom).offset(8)
      maker.left.equalToSuperview().offset(16)
      maker.right.equalToSuperview().offset(-16)
      maker.height.equalTo(48)
    }

    lblRegister.text = "등록일"
    lblRegister.snp.makeConstraints { maker in
      maker.top.equalTo(txtFoodName.snp.bottom).offset(10)
      maker.left.equalToSuperview().offset(16)
      maker.right.equalToSuperview().offset(-16)
    }
    lblRegister.font = UIFont.systemFont(ofSize: 17)

    txtRegisterDate.snp.makeConstraints { maker in
      maker.top.equalTo(lblRegister.snp.bottom).offset(8)
      maker.left.equalToSuperview().offset(16)
      maker.right.equalToSuperview().offset(-16)
      maker.height.equalTo(48)
    }

    lblExpire.text = "유통기한"
    lblExpire.snp.makeConstraints { maker in
      maker.top.equalTo(txtRegisterDate.snp.bottom).offset(10)
      maker.left.equalToSuperview().offset(16)
      maker.right.equalToSuperview().offset(-16)
    }
    lblName.font = UIFont.systemFont(ofSize: 17)

    txtExpireDate.snp.makeConstraints { maker in
      maker.top.equalTo(lblExpire.snp.bottom).offset(8)
      maker.left.equalToSuperview().offset(16)
      maker.right.equalToSuperview().offset(-16)
      maker.height.equalTo(48)
    }

    btnRegister.setTitle("등록", for: .normal)
    btnRegister.setTitleColor(.white, for: .normal)
    btnRegister.backgroundColor = .blue
    btnRegister.snp.makeConstraints { maker in
      maker.left.equalToSuperview()
      maker.right.equalToSuperview()
      maker.bottom.equalToSuperview()
      maker.height.equalTo(48)
    }
  }
}
