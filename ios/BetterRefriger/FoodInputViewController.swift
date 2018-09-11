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
  private var activeField: MJTextField?
  private lazy var scrollView = UIScrollView()
  private lazy var contentsView = UIView()
  private lazy var txtFoodName = MJTextField()
  private lazy var txtRegisterDate = MJTextField()
  private lazy var txtExpireDate = MJTextField()
  private lazy var btnRegister = UIButton()

  func touchInputComplete(_ sender: UIButton) {
  }

  override func viewDidLoad() {
    drawUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                           name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                           name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  func drawUI() {
    view.backgroundColor = .white
    activeField = txtExpireDate
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { maker in
      maker.edges.equalToSuperview()
    }

    scrollView.addSubview(contentsView)
    contentsView.snp.makeConstraints { maker in
      maker.edges.equalToSuperview()
      maker.width.equalToSuperview()
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
      maker.top.equalToSuperview().offset(10)
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
      maker.bottom.equalToSuperview().offset(-16)
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

  @objc func keyboardWillShow(_ notification: Notification) {
    let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
    let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets

    var viewRect = view.frame
    viewRect.size.height -= keyboardSize.height
    if viewRect.contains(activeField!.frame.origin) {
      let scrollPoint = CGPoint(x: 0, y: activeField!.frame.origin.y - keyboardSize.height)
      if scrollPoint.y > 0 {
        scrollView.setContentOffset(scrollPoint, animated: true)
      }
    }
  }

  @objc func keyboardWillHide(_ notification: Notification) {
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
  }
}
