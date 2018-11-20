//
//  Food.swift
//  BetterRefriger
//
//  Created by 최명지 on 20/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit
import CoreData

class FoodModel: NSObject {
  private var foods: [NSManagedObject] = []

  override init() {
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

  func save(refrigerType: Int, name: String, registerDate: Date, expireDate: Date) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let lastSeq = foods.reduce(0) { (startValue: Int, food: NSManagedObject) -> Int in
      return [startValue, food.value(forKey: "seq") as? Int ?? 0].max()!
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)!
    let food = NSManagedObject(entity: entity, insertInto: managedContext)

    food.setValue(refrigerType == 0 ? "refriger" : "freezer", forKey: "refrigerType")
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
  }

  func data(refrigerType: Int) -> [NSManagedObject] {
    let state = refrigerType == 0 ? "refriger" : "freezer"
    let food = foods.filter({ food -> Bool in
      food.value(forKey: "refrigerType") as? String == state
    })
    return food
  }

  func remove(indexAt seq: Int) {
    if let dataAppDelegatde = UIApplication.shared.delegate as? AppDelegate {
      let mngdCntxt = dataAppDelegatde.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")

      let predicate = NSPredicate(format: "seq = %i", self.foods[seq].value(forKey: "seq") as? Int ?? 0)
      print(self.foods[seq].value(forKey: "seq") as? Int ?? 0)

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
  }


}


