//
//  MainViewController.swift
//  BetterRefriger
//
//  Created by Myungji on 2017. 2. 12..
//  Copyright © 2017년 maengji.com. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import UserNotifications
import SnapKit
import XLPagerTabStrip

class MainViewController: UIViewController, ViewType {

  private let cellId = "FoodListTableViewCell"
  private var tableView = UITableView()
  private var refrigerString = "refriger"

  var viewModel: MainViewModel!
  var disposeBag: DisposeBag!

  private lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil).then {
    $0.tintColor = .white
  }

  func setupUI() {
    self.navigationItem.title = "더나은냉장고"
    self.navigationItem.rightBarButtonItem = addButton

    let view = self.view!

    if #available(iOS 11.0, *) {
      let guide = view.safeAreaLayoutGuide
      view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = false
      view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = false
    }

    view.addSubviews(tableView, freezeButton, refrigerButton)

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    refrigerButton.snp.makeConstraints {
      $0.left.equalToSuperview().inset(18)
      $0.bottom.equalToSuperview().inset(64)
      $0.width.height.equalTo(54)
    }

    freezeButton.snp.makeConstraints {
      $0.left.equalToSuperview().inset(18)
      $0.bottom.equalTo(refrigerButton.snp.top).offset(-8)
      $0.width.height.equalTo(54)
    }
  }

  func setupEventBinding() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FoodListTableViewCell.self, forCellReuseIdentifier: cellId)

    addButton.rx.tap
      .flatMap(selectedColor)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] food in
        print(food)
        self?.save(refrigerType: food.refrigerType,
                               name: food.foodName,
                               registerDate: food.registerDate,
                               expireDate: food.expireDate)
        }, onError: { error in
          print(error)
      }, onCompleted: {
        print("completed")
      }).disposed(by: disposeBag)

    refrigerButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.refrigerString = "refriger"
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)

    freezeButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.refrigerString = "freezer"
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }

  func setupUIBinding() {
  }

  func selectedColor() -> Observable<FoodInputModel> {
    let foodInputViewModel = FoodInputViewModel()
    let foodInputVC = FoodInputViewController.create(with: foodInputViewModel)
    navigationController?.pushViewController(foodInputVC, animated: true)
    return foodInputVC.inputFood
  }

  func inputFoodCompleted(_ refrigerType: RefrigerType, foodName: String, registerDate: Date, expireDate: Date) {
    save(refrigerType: refrigerType, name: foodName, registerDate: registerDate, expireDate: expireDate )
    tableView.reloadData()
  }

  private lazy var refrigerButton = SelectAreaButton().then {
    $0.setTitle("냉장", for: .normal)
  }

  private lazy var freezeButton = SelectAreaButton().then {
    $0.setTitle("냉동", for: .normal)
  }

  func save(refrigerType: RefrigerType, name: String, registerDate: Date, expireDate: Date) {
    viewModel.save(refrigerType: refrigerType, name: name, registerDate: registerDate, expireDate: expireDate)
    tableView.reloadData()

    let noti = NotificationManager()
    noti.name = name
    noti.expireDate = expireDate
    noti.requestNotification()
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.foods(refrigerType: RefrigerType(keyString: self.refrigerString)).count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return FoodListTableViewCell.rowHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let food = viewModel.foods(refrigerType: RefrigerType(keyString: self.refrigerString))[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FoodListTableViewCell
    cell?.seq = food.value(forKey: "seq") as? Int
    cell?.name = food.value(forKey: "name") as? String
    cell?.registerDate = food.value(forKey: "registerDate") as? Date
    cell?.expireDate = food.value(forKey: "expireDate") as? Date

    return cell!
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (_, indexPath) in
      self.viewModel.remove(indexAt: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }

    return [delete]
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let food = viewModel.foods(refrigerType: RefrigerType(keyString: self.refrigerString))[indexPath.row]
    let foodInputModel = FoodInputModel()
    foodInputModel.seq = food.value(forKey: "seq") as! Int
    foodInputModel.foodName = food.value(forKey: "name") as! String
    foodInputModel.registerDate = food.value(forKey: "registerDate") as! Date
    foodInputModel.expireDate = food.value(forKey: "expireDate") as! Date

    let foodInputController = FoodInputViewController.create(with: FoodInputViewModel())
    navigationController?.pushViewController(foodInputController, animated: true)
  }
}
