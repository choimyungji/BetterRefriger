//
//  ViewController.swift
//  BetterRefriger
//
//  Created by Myungji on 2017. 2. 12..
//  Copyright © 2017년 maengji.com. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, FoodInputViewControllerDelegate {
    func inputFoodCompleted(_ foodName: String, registerDate: String, expireDate: String) {
        print(foodName, registerDate, expireDate)
    }

    var foods: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "냉장고를 부탁해"
        let anotherButton = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self, action: #selector(touchPlusButton(_:)))
        self.navigationItem.rightBarButtonItem = anotherButton

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

//        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action -> Void in
//            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
//                return
//            }
//
//            self.save(name: nameToSave)
//            self.tableView.reloadData()
//        })
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
//
//        alert.addTextField()
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
    }

    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)!
        let food = NSManagedObject(entity: entity, insertInto: managedContext)

        food.setValue(name, forKey: "name")

        do {
            try managedContext.save()
            foods.append(food)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = foods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = food.value(forKey: "name") as? String

        return cell
    }
}
