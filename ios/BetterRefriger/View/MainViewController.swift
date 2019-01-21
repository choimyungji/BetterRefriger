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
        self?.save(spaceType: food.spaceType,
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
        self?.freezeButton.isSelected = false
        self?.refrigerButton.isSelected = true
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)

    freezeButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.refrigerString = "freezer"
        self?.freezeButton.isSelected = true
        self?.refrigerButton.isSelected = false
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)

//    tableView.rx.itemSelected
//      .subscribe(onNext: { [weak self] indexPath in
//        let food = self!.viewModel.foods(spaceType: SpaceType(keyString: self!.refrigerString))[indexPath.row]
//        let foodModel = FoodModel()
//        foodModel.spaceType = SpaceType(keyString: self!.refrigerString)
//        foodModel.seq = food.value(forKey: "seq") as! Int
//        foodModel.foodName = food.value(forKey: "name") as! String
//        foodModel.registerDate = food.value(forKey: "registerDate") as! Date
//        foodModel.expireDate = food.value(forKey: "expireDate") as! Date
//
//        let foodInputController = FoodInputViewController.create(with: FoodInputViewModel(initialData: foodModel, completion: nil))
//        self?.navigationController?.pushViewController(foodInputController, animated: true)
//      }, onCompleted: {
//        print("COMPLETED")
//      })
//      .disposed(by: disposeBag)
  }

  func setupUIBinding() {
  }

  func selectedColor() -> Observable<FoodModel> {
    let foodInputViewModel = FoodInputViewModel()
    let foodInputVC = FoodInputViewController.create(with: foodInputViewModel)
    navigationController?.pushViewController(foodInputVC, animated: true)
    return foodInputVC.inputFood
  }

//  func inputFoodCompleted(_ spaceType: SpaceType, foodName: String, registerDate: Date, expireDate: Date) {
//    save(spaceType: spaceType, name: foodName, registerDate: registerDate, expireDate: expireDate )
//    tableView.reloadData()
//  }

  private lazy var refrigerButton = SelectAreaButton().then {
    $0.setTitle("냉장", for: .normal)
    $0.isSelected = true
  }

  private lazy var freezeButton = SelectAreaButton().then {
    $0.setTitle("냉동", for: .normal)
  }

  func save(spaceType: SpaceType, name: String, registerDate: Date, expireDate: Date) {
    viewModel.save(spaceType: spaceType, name: name, registerDate: registerDate, expireDate: expireDate)
    tableView.reloadData()

    let noti = NotificationManager()
    noti.name = name
    noti.expireDate = expireDate
    noti.requestNotification()
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.foods(spaceType: SpaceType(keyString: self.refrigerString)).count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return FoodListTableViewCell.rowHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let food = viewModel.foods(spaceType: SpaceType(keyString: self.refrigerString))[indexPath.row]

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
    let food = viewModel.foods(spaceType: SpaceType(keyString: refrigerString))[indexPath.row]
    let foodModel = FoodModel()
    foodModel.spaceType = SpaceType(keyString: refrigerString)
    foodModel.seq = food.value(forKey: "seq") as! Int
    foodModel.foodName = food.value(forKey: "name") as! String
    foodModel.registerDate = food.value(forKey: "registerDate") as! Date
    foodModel.expireDate = food.value(forKey: "expireDate") as! Date

    let foodInputController = FoodInputViewController.create(with: FoodInputViewModel(initialData: foodModel, completion: nil))
    foodInputController.delegate = self
    navigationController?.pushViewController(foodInputController, animated: true)

  }
}

extension MainViewController: FoodInputViewControllerDelegate {
  func inputFoodCompleted(food: FoodModel) {
    print("1")
  }
}

