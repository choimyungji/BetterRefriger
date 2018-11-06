//
//  ViewController.swift
//  BetterRefriger
//
//  Created by Myungji on 2017. 2. 12..
//  Copyright © 2017년 maengji.com. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UITableViewController, FoodInputViewControllerDelegate {
    var foods: [NSManagedObject] = []

    func inputFoodCompleted(_ foodName: String, registerDate: Date, expireDate: Date) {
        save(name: foodName, registerDate: registerDate, expireDate: expireDate )
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "더나은냉장고"
        let anotherButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self, action: #selector(touchPlusButton(_:)))
        self.navigationItem.rightBarButtonItem = anotherButton

        tableView.register(FoodListTableViewCell.self, forCellReuseIdentifier: "Cell")
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

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)!
        let food = NSManagedObject(entity: entity, insertInto: managedContext)

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FoodListTableViewCell.rowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = foods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? FoodListTableViewCell
        cell?.name = food.value(forKey: "name") as? String
        cell?.registerDate = food.value(forKey: "registerDate") as? Date
        cell?.expireDate = food.value(forKey: "expireDate") as? Date

        return cell!
    }
}

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
