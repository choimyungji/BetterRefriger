//
//  SpaceManager.swift
//  BetterRefriger
//
//  Created by 최명지 on 08/01/2019.
//  Copyright © 2019 maengji.com. All rights reserved.
//

import UIKit
import CoreData

class SpaceManager: NSObject {
    private var spaces: [NSManagedObject] = []

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

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Space")

        do {
            spaces = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Space", in: managedContext)!
        let space = NSManagedObject(entity: entity, insertInto: managedContext)

        space.setValue("1", forKey: "refrigerType")
        space.setValue("2", forKey: "seq")

        do {
            try managedContext.save()
            spaces.append(space)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func data(spaceType: SpaceType) -> [NSManagedObject] {
        let food = spaces.filter({ food -> Bool in
            food.value(forKey: "refrigerType") as? String == spaceType.keyString
        })
        return food
    }

    func remove(indexAt seq: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")

        let predicate = NSPredicate(format: "seq = %i", self.spaces[seq].value(forKey: "seq") as? Int ?? 0)
        print(self.spaces[seq].value(forKey: "seq") as? Int ?? 0)

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

    func setDefaultData() {

    }
}
