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

class FoodInputViewController: UIViewController, ViewType, UIPickerViewDelegate, UITextFieldDelegate {

  var viewModel: FoodInputViewModel!
  var disposeBag: DisposeBag!

  private let foodInputSubject = PublishSubject<FoodInputModel>()
  var inputFood: Observable<FoodInputModel> {
    return foodInputSubject.asObservable()
  }

  private var selectedDate: Date?
  private var registerDate: Date?
  private var expireDate: Date?
  private var activeField: MJTextField?
  private let datePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.locale = Locale(identifier: "ko")
    picker.datePickerMode = .date
    return picker
  }()

  func setupUI() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.addSubview(contentsView)
    view.addSubview(btnRegister)
    contentsView.addSubviews([segRefrigerType, lblName, txtFoodName, lblRegister,
                              btnRegisterToday, txtRegisterDate, lblExpire, btnOneWeek,
                              btnOneMonth, txtExpireDate])

    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    contentsView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.greaterThanOrEqualToSuperview()
    }

    segRefrigerType.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(40)
    }

    lblName.snp.makeConstraints {
      $0.top.equalTo(segRefrigerType.snp.bottom).offset(16)
      $0.left.right.equalToSuperview().inset(16)
    }

    txtFoodName.snp.makeConstraints {
      $0.top.equalTo(lblName.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(16)
    }

    lblRegister.snp.makeConstraints {
      $0.top.equalTo(txtFoodName.snp.bottom).offset(10)
      $0.left.equalToSuperview().inset(16)
    }

    btnRegisterToday.snp.makeConstraints {
      $0.top.equalTo(lblRegister)
      $0.left.equalTo(lblRegister.snp.right).offset(10)
      $0.right.equalToSuperview().inset(16)
    }

    txtRegisterDate.snp.makeConstraints {
      $0.top.equalTo(btnRegisterToday.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(16)
    }

    lblExpire.snp.makeConstraints {
      $0.top.equalTo(txtRegisterDate.snp.bottom).offset(10)
      $0.left.right.equalToSuperview().inset(16)
    }

    btnOneWeek.snp.makeConstraints {
      $0.top.equalTo(lblExpire)
      $0.right.equalTo(btnOneMonth.snp.left).offset(-4)
    }

    btnOneMonth.snp.makeConstraints {
      $0.top.equalTo(btnOneWeek)
      $0.right.equalToSuperview().inset(16)
    }

    txtExpireDate.snp.makeConstraints {
      $0.top.equalTo(lblExpire.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(16)
    }

    btnRegister.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      if #available(iOS 11.0, *) {
        $0.height.equalTo(48 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0))
      } else {
        $0.height.equalTo(48)
      }
    }
  }

  func setupEventBinding() {
    btnRegister.rx.tap
      .subscribe(onNext: { [weak self] _ in
        let food = FoodInputModel()
        food.refrigerType = self?.segRefrigerType.selectedSegmentIndex == 0 ? .refriger : .freezer
        food.foodName = self!.txtFoodName.text!
        food.registerDate = self!.registerDate!
        food.expireDate = self!.expireDate!

        self?.complete(food: food)
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)

    btnRegisterToday.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.registerDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self?.txtRegisterDate.text = dateFormatter.string(from: self!.registerDate!)
      })
      .disposed(by: disposeBag)

    btnOneWeek.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.expireDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self?.txtExpireDate.text = dateFormatter.string(from: self!.expireDate!)
      })
      .disposed(by: disposeBag)

    btnOneMonth.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.expireDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self?.txtExpireDate.text = dateFormatter.string(from: self!.expireDate!)
      })
      .disposed(by: disposeBag)

    let foodNameValid = txtFoodName.rx.text.orEmpty
      .map { $0.count >= 1 }
      .share(replay: 1)

    let registerDateValid = txtRegisterDate.rx.text.orEmpty
      .map { $0.count == 10 }
      .share(replay: 1)

    let expireDateValid = txtExpireDate.rx.text.orEmpty
      .map { $0.count == 10 }
      .share(replay: 1)

    let everythingValid = Observable.combineLatest(foodNameValid, registerDateValid, expireDateValid) { $0 && $1 && $2 }
      .share(replay: 1)

    everythingValid
      .bind(to: btnRegister.rx.isEnabled)
      .disposed(by: disposeBag)
  }

  func setupUIBinding() {

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    activeField = txtExpireDate
    txtRegisterDate.delegate = self
    txtExpireDate.delegate = self

    setTabBackGround()
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

  let scrollView =  UIScrollView()
  let contentsView = UIView()
  let segRefrigerType: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["냉장고", "냉동실"])
    segmentedControl.selectedSegmentIndex = 0
    return segmentedControl
  }()

  let lblName: UILabel = {
    let label = UILabel()
    label.text = "식품명"
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()
  let txtFoodName = MJTextField()

  let lblRegister: UILabel = {
    let label = UILabel()
    label.text = "등록일"
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()

  let btnRegisterToday: LabelButton = {
    let button = LabelButton(labelText: "오늘")
    return button
  }()

  let txtRegisterDate = MJTextField()

  let lblExpire: UILabel = {
    let label = UILabel()
    label.text = "유통기한"
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()

  let btnOneWeek = LabelButton(labelText: "1주일")
  let btnOneMonth = LabelButton(labelText: "1달")

  let txtExpireDate = MJTextField()
  let btnRegister: UIButton = {
    let button = UIButton()
    button.setTitle("등록", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor.BRColorOnActive
    return button
  }()

  @objc func keyboardWillShow(_ notification: Notification) {
    let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
    let keyboard = userInfo.object(forKey: UIResponder.keyboardFrameBeginUserInfoKey)! as AnyObject
    let keyboardSize = keyboard.cgRectValue.size
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
      selectedDate = Date()
      datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControl.Event.valueChanged)
      txtRegisterDate.inputView = datePicker
      let toolBar = UIToolbar().toolbarPicker(mySelect: #selector(dismissPicker))
      textField.inputAccessoryView = toolBar
    }

    if textField == txtExpireDate {
      selectedDate = Date()
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
    guard let selectedDate = selectedDate else { return }

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

  func complete(food: FoodInputModel) {
    self.foodInputSubject.onNext(food)
    self.foodInputSubject.onCompleted()
  }
}
