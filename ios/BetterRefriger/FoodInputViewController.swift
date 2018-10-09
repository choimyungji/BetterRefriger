//
//  FoodInputViewController.swift
//  BetterRefriger
//
//  Created by Myungji on 2017. 9. 22..
//  Copyright © 2017년 maengji.com. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

public protocol FoodInputViewControllerDelegate: NSObjectProtocol {
  func inputFoodCompleted(_ foodName: String, registerDate: Date, expireDate: Date)
}

class FoodInputViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
  weak var delegate: FoodInputViewControllerDelegate?

  private var activeField: MJTextField?
  private lazy var scrollView = UIScrollView()
  private lazy var contentsView = UIView()
  private lazy var txtFoodName = MJTextField()
  private lazy var txtRegisterDate = MJTextField()
  private lazy var txtExpireDate = MJTextField()
  private lazy var btnRegister = UIButton()

  private let datePicker = UIDatePicker()
  private var selectedDate: Date?
  private var registerDate: Date?
  private var expireDate: Date?

  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    btnRegister.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.delegate?.inputFoodCompleted(self!.txtFoodName.text!,
                                     registerDate: self!.registerDate!,
                                     expireDate: self!.expireDate!)
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)


    setTabBackGround()
    drawUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  func setTabBackGround() {
    let tapBackground = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
    tapBackground.numberOfTapsRequired = 1
    self.view.addGestureRecognizer(tapBackground)
  }

  @objc func dismissKeyboard(_ sender: AnyObject) {
    self.view.endEditing(true)
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
      maker.edges.width.equalToSuperview()
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

    txtRegisterDate.delegate = self
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

    txtExpireDate.delegate = self
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
      maker.left.right.bottom.equalToSuperview()
      maker.height.equalTo(48)
    }
  }

  @objc func keyboardWillShow(_ notification: Notification) {
    let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
    let keyboardSize = (userInfo.object(forKey: UIResponder.keyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets

    btnRegister.snp.updateConstraints { maker in
      maker.bottom.equalToSuperview().offset(-keyboardSize.height)
    }

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

    btnRegister.snp.updateConstraints { maker in
      maker.bottom.equalToSuperview()
    }
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeField = textField as? MJTextField

    if textField == txtRegisterDate {
      let datePicker = UIDatePicker()
      datePicker.datePickerMode = .date
      datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.valueChanged)

      txtRegisterDate.inputView = datePicker
      let toolBar = UIToolbar().toolbarPicker(mySelect: #selector(dismissPicker))
      textField.inputAccessoryView = toolBar
    }

    if textField == txtExpireDate {
      let datePicker = UIDatePicker()
      datePicker.datePickerMode = .date
      datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.valueChanged)

      txtExpireDate.inputView = datePicker
      let toolBar = UIToolbar().toolbarPicker(mySelect: #selector(dismissPicker))
      textField.inputAccessoryView = toolBar
    }
  }

  @objc func handleDatePicker(_ sender: UIDatePicker) {
    selectedDate = sender.date
  }

  @objc func dismissPicker() {
    guard let selectedDate = selectedDate else {
      return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    if activeField == txtRegisterDate {
      registerDate = selectedDate
      txtRegisterDate.text = dateFormatter.string(from: selectedDate)
    } else if activeField == txtExpireDate {
      expireDate = selectedDate
      txtExpireDate.text = dateFormatter.string(from: selectedDate)
    }

    view.endEditing(true)
  }
}
