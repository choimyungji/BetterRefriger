//
//  Food.swift
//  BetterRefriger
//
//  Created by 최명지 on 20/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit
import CoreData

class FoodModelService: NSObject {
  private var foods: [NSManagedObject] = []

  var managedContext: NSManagedObjectContext
  let persistentContainer: NSPersistentContainer

  override init() {
    persistentContainer = NSPersistentContainer(name: "BetterRefriger")
    persistentContainer.loadPersistentStores { (_, error) in
      guard error == nil else {
        fatalError(error!.localizedDescription)
      }
    }
    managedContext = persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Food")

    do {
      foods = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func save(spaceType: SpaceType, name: String, registerDate: Date, expireDate: Date) {

    let lastSeq = foods.reduce(0) { (startValue: Int, food: NSManagedObject) -> Int in
      return [startValue, food.value(forKey: "seq") as? Int ?? 0].max()!
    }

    let entity = NSEntityDescription.entity(forEntityName: "Food", in: managedContext)!
    let food = NSManagedObject(entity: entity, insertInto: managedContext)

    food.setValue(spaceType.keyString, forKey: "refrigerType")
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

  func data(spaceType: SpaceType) -> [NSManagedObject] {
    let food = foods.filter({ food -> Bool in
      food.value(forKey: "refrigerType") as? String == spaceType.keyString
    })
    return food
  }

  func remove(indexAt seq: Int) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")

    let predicate = NSPredicate(format: "seq = %i", self.foods[seq].value(forKey: "seq") as? Int ?? 0)
    print(self.foods[seq].value(forKey: "seq") as? Int ?? 0)

    fetchRequest.predicate = predicate
    do {
      let result = try managedContext.fetch(fetchRequest)

      print(result.count)

      if result.count > 0 {
        for object in result {
          print(object)
          managedContext.delete(object as? NSManagedObject ?? NSManagedObject(context: managedContext))
        }
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}
