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

  private lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

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
      .subscribe(onNext: { [weak self] _ in
        let spaceType = SpaceType(keyString: self?.refrigerString ?? "")
        let foodInputViewModel = FoodInputViewModel(spaceType: spaceType)

        let foodInputVC = FoodInputViewController.create(with: foodInputViewModel)
        foodInputVC.inputFood
          .subscribe(onNext: { food in
            self?.save(spaceType: spaceType,
                       food: food)
          }).disposed(by: self!.disposeBag)
        self?.navigationController?.pushViewController(foodInputVC, animated: true)
        },
                 onError: { error in
                  print(error)
      },
                 onCompleted: {
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

    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        let spaceType = SpaceType(keyString: self.refrigerString)
        let food = self.viewModel.foods(spaceType: spaceType)[indexPath.row]
        let foodModel = FoodModel()
        foodModel.seq = food.value(forKey: "seq") as! Int
        foodModel.foodName = food.value(forKey: "name") as! String
        foodModel.registerDate = food.value(forKey: "registerDate") as! Date
        foodModel.expireDate = food.value(forKey: "expireDate") as! Date

        let foodInputController = FoodInputViewController.create(with: FoodInputViewModel(food: foodModel, spaceType: spaceType))
        foodInputController.inputFood
          .subscribe(onNext: { food in
            self.update(spaceType: spaceType,
                         seq: food.seq,
                         name: food.foodName,
                         registerDate: food.registerDate,
                         expireDate: food.expireDate)
          })
          .disposed(by: self.disposeBag)
        self.navigationController?.pushViewController(foodInputController, animated: true)
      }, onCompleted: {
        print("COMPLETED")
      })
      .disposed(by: disposeBag)
  }

  func setupUIBinding() {
  }

  func selectedColor() -> Observable<FoodModel> {
    let spaceType = SpaceType(keyString: refrigerString)
    var foodInputViewModel = FoodInputViewModel(spaceType: spaceType)

    let foodInputVC = FoodInputViewController.create(with: foodInputViewModel)
    navigationController?.pushViewController(foodInputVC, animated: true)
    return foodInputVC.inputFood
  }

  private lazy var refrigerButton = SelectAreaButton().then {
    $0.setTitle("냉장", for: .normal)
    $0.isSelected = true
  }

  private lazy var freezeButton = SelectAreaButton().then {
    $0.setTitle("냉동", for: .normal)
  }

  func save(spaceType: SpaceType, food: FoodModel) {
    viewModel.save(spaceType: spaceType, food: food)
    tableView.reloadData()
  }

  func update(spaceType: SpaceType, seq: Int, name: String, registerDate: Date, expireDate: Date) {
    viewModel.update(spaceType: spaceType, seq: seq, name: name, registerDate: registerDate, expireDate: expireDate)
    tableView.reloadData()

//    let noti = NotificationManager.getInstance
//    noti.name = name
//    noti.expireDate = expireDate
//    noti.requestNotification()
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
      let food = self.viewModel.foods(spaceType: SpaceType(keyString: self.refrigerString))[indexPath.row]
      self.viewModel.remove(indexAt: food.value(forKey: "seq") as! Int)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }

    return [delete]
  }
}
