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
import Then

class FoodInputViewController: UIViewController, ViewType, UIPickerViewDelegate, UITextFieldDelegate {
  var viewModel: FoodInputViewModel!
  var disposeBag: DisposeBag!

  private let foodInputSubject = PublishSubject<FoodModel>()
  var inputFood: Observable<FoodModel> {
    return foodInputSubject.asObservable()
  }

  private var seq: Int?
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
    view.addSubviews(scrollView, btnRegister)
    scrollView.addSubview(contentsView)

    contentsView.addSubviews(segSpaceType, lblName, txtFoodName, lblRegister,
                             btnRegisterToday, txtRegisterDate, lblExpire, btnOneWeek,
                             btnOneMonth, txtExpireDate)

    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    contentsView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.greaterThanOrEqualToSuperview()
    }

    segSpaceType.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.left.right.equalToSuperview().inset(16)
      $0.height.equalTo(40)
    }

    lblName.snp.makeConstraints {
      $0.top.equalTo(segSpaceType.snp.bottom).offset(16)
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
      $0.left.right.equalToSuperview()
      $0.height.equalTo(48)
      $0.bottom.equalToSuperview()
        .inset(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
    }
  }

  func setupEventBinding() {
    btnRegister.rx.tap
      .subscribe(onNext: { [weak self] _ in
        let food = FoodModel()
        food.seq = self!.seq!
        food.foodName = self!.txtFoodName.text!
        food.registerDate = self!.registerDate!
        food.expireDate = self!.expireDate!

        let spaceType = SpaceType(keyString: self?.segSpaceType.selectedSegmentIndex == 0 ? "refriger" : "freezer")
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
    segSpaceType.selectedSegmentIndex = viewModel.spaceType.keyString == "refriger" ? 0 : 1
    seq = viewModel.seq
    txtFoodName.text = viewModel.foodName
    registerDate = viewModel.registerDate
    expireDate = viewModel.expireDate

    guard let registerDate = registerDate, let expireDate = expireDate else { return }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    txtRegisterDate.text = dateFormatter.string(from: registerDate)
    txtExpireDate.text = dateFormatter.string(from: expireDate)

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

  private lazy var scrollView =  UIScrollView()
  private lazy var contentsView = UIView()
  private lazy var segSpaceType = UISegmentedControl(items: ["냉장고", "냉동실"]).then {
    $0.selectedSegmentIndex = 0
    $0.tintColor = UIColor.BRColorBlack
  }
  private lazy var lblName = UILabel().then {
    $0.text = "식품명"
    $0.font = UIFont.systemFont(ofSize: 17)
  }
  private lazy var txtFoodName = MJTextField()
  private lazy var lblRegister = UILabel().then {
    $0.text = "등록일"
    $0.font = UIFont.systemFont(ofSize: 17)
  }
  private lazy var btnRegisterToday = LabelButton(labelText: "오늘")
  private lazy var txtRegisterDate = MJTextField()
  private lazy var lblExpire = UILabel().then {
    $0.text = "유통기한"
    $0.font = UIFont.systemFont(ofSize: 17)
  }
  private lazy var btnOneWeek = LabelButton(labelText: "1주일")
  private lazy var btnOneMonth = LabelButton(labelText: "1달")
  private lazy var txtExpireDate = MJTextField()
  private lazy var btnRegister = UIButton().then {
    $0.setTitle("등록", for: .normal)
    $0.setTitleColor(.BRColorBlack, for: .normal)
    $0.backgroundColor = UIColor.BRColorOnActive
  }

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

  func complete(food: FoodModel) {
    self.foodInputSubject.onNext(food)
    self.foodInputSubject.onCompleted()
  }
}
