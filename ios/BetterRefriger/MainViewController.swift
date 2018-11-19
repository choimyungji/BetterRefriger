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

class MainViewController: UIViewController, FoodInputViewControllerDelegate {

  var foods: [NSManagedObject] = []

  private let cellId = "FoodListTableViewCell"
  private var tableView = UITableView()
  private var state = "refriger"

  private var disposeBag = DisposeBag()

  func inputFoodCompleted(_ foodName: String, registerDate: Date, expireDate: Date) {
    save(name: foodName, registerDate: registerDate, expireDate: expireDate )
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

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(FoodListTableViewCell.self, forCellReuseIdentifier: cellId)
    setNavBar()
  }

  func setNavBar() {
    self.navigationItem.title = "더나은냉장고"
    let anotherButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self, action: #selector(touchPlusButton(_:)))
    self.navigationItem.rightBarButtonItem = anotherButton
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Food")

    do {
      foods = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    refrigerButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.state = "refriger"
      })
      .disposed(by: disposeBag)

    freezeButton.rx.tap
      .subscribe(onNext: {[weak self] _ in
        self?.state = "freeze"
      })
      .disposed(by: disposeBag)

    setupViews()
  }

  func setupViews() {
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

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @objc func touchPlusButton(_ sender: AnyObject) {
    let foodInputVC = FoodInputViewController()
    foodInputVC.delegate = self
    self.navigationController?.pushViewController(foodInputVC, animated: true)
  }

  func save(name: String, registerDate: Date, expireDate: Date) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let lastSeq = foods.reduce(0) { (startValue: Int, food: NSManagedObject) -> Int in
      return [startValue, food.value(forKey: "seq") as? Int ?? 0].max()!
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)!
    let food = NSManagedObject(entity: entity, insertInto: managedContext)

    food.setValue(lastSeq+1, forKey: "seq")
    food.setValue(name, forKey: "name")
    food.setValue(registerDate, forKey: "registerDate")
    food.setValue(expireDate, forKey: "expireDate")

    do {
      try managedContext.save()
      foods.append(food)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }

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
    return foods.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return FoodListTableViewCell.rowHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let food = foods[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FoodListTableViewCell
    cell?.seq = food.value(forKey: "seq") as? Int
    cell?.name = food.value(forKey: "name") as? String
    cell?.registerDate = food.value(forKey: "registerDate") as? Date
    cell?.expireDate = food.value(forKey: "expireDate") as? Date

    return cell!
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (_, indexPath) in

      if let dataAppDelegatde = UIApplication.shared.delegate as? AppDelegate {
        let mngdCntxt = dataAppDelegatde.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")

        let predicate = NSPredicate(format: "seq = %i", self.foods[indexPath.row].value(forKey: "seq") as? Int ?? 0)
        print(self.foods[indexPath.row].value(forKey: "seq") as? Int ?? 0)

        fetchRequest.predicate = predicate
        do {
          let result = try mngdCntxt.fetch(fetchRequest)

          print(result.count)

          if result.count > 0 {
            for object in result {
              print(object)
              mngdCntxt.delete(object as? NSManagedObject ?? NSManagedObject(context: mngdCntxt))
            }
            try mngdCntxt.save()
          }
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }

      self.foods.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      print(self.foods)
    }

    return [delete]
  }
}
