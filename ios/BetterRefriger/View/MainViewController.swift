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

class MainViewController: UIViewController, ViewType {

  var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

  func setupUI() {
    self.navigationItem.title = "더나은냉장고"
    self.navigationItem.rightBarButtonItem = addButton

    view.addSubview(tableView)
    view.addSubview(freezeButton)
    view.addSubview(refrigerButton)

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

  func selectedColor() -> Observable<FoodInputModel> {
    let foodInputVC = FoodInputViewController()
    navigationController?.pushViewController(foodInputVC, animated: true)
    return foodInputVC.inputFood
  }

  func setupEventBinding() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FoodListTableViewCell.self, forCellReuseIdentifier: cellId)

    addButton.rx.tap
      .flatMap(selectedColor)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (food) in
        self?.save(refrigerType: food.refrigerType.rawValue,
                   name: food.foodName,
                   registerDate: food.registerDate,
                   expireDate: food.expireDate)
      })
      .disposed(by: disposeBag)

    refrigerButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.state = 0
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)

    freezeButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.state = 1
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }

  func setupUIBinding() {

  }

  var foodss = FoodModelService()

  private let cellId = "FoodListTableViewCell"
  private var tableView = UITableView()
  private var state = 0

  var viewModel: MainViewModel!
  var disposeBag: DisposeBag!

  func inputFoodCompleted(_ refrigerType: Int, foodName: String, registerDate: Date, expireDate: Date) {
    save(refrigerType: refrigerType, name: foodName, registerDate: registerDate, expireDate: expireDate )
    tableView.reloadData()
  }

  var refrigerButton: SelectAreaButton = {
    let button = SelectAreaButton()
    button.setTitle("냉장", for: .normal)
    return button
  }()

  var freezeButton: SelectAreaButton = {
    let button = SelectAreaButton()
    button.setTitle("냉동", for: .normal)
    return button
  }()

//  @objc func touchPlusButton(_ sender: AnyObject) {
////    let foodInputVC = FoodInputViewController()
////    foodInputVC.delegate = self
////    self.navigationController?.pushViewController(foodInputVC, animated: true)
//  }

  func save(refrigerType: Int, name: String, registerDate: Date, expireDate: Date) {
    foodss.save(refrigerType: refrigerType, name: name, registerDate: registerDate, expireDate: expireDate)
    tableView.reloadData()
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]

    center.requestAuthorization(options: options) { (granted, error) in
      if granted {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "expireNotification"
        content.body = "\(name)의 유통기한이 다 되어갑니다."
        let calendar = Calendar.current

        var components = calendar.dateComponents([.hour, .minute, .second], from: expireDate)

        components.hour = 21
        components.minute = 12

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "expireNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
          print(error?.localizedDescription ?? "")
        }
      }
    }
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foodss.data(refrigerType: state).count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return FoodListTableViewCell.rowHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let food = foodss.data(refrigerType: state)[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FoodListTableViewCell
    cell?.seq = food.value(forKey: "seq") as? Int
    cell?.name = food.value(forKey: "name") as? String
    cell?.registerDate = food.value(forKey: "registerDate") as? Date
    cell?.expireDate = food.value(forKey: "expireDate") as? Date

    return cell!
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (_, indexPath) in
      self.foodss.remove(indexAt: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }

    return [delete]
  }
}
