//
//  CoreDataStack.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 20/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import CoreData

class CoreDataStack {

  static let shared = CoreDataStack()

  let persistentContainer: NSPersistentContainer
  lazy var managedObjectContext: NSManagedObjectContext = {
    return persistentContainer.viewContext
  }()
  let modelName = "BetterRefriger"

  private init() {
    persistentContainer = NSPersistentContainer(name: modelName)
    persistentContainer.loadPersistentStores { (_, error) in
      guard error == nil else {
        fatalError(error!.localizedDescription)
      }
    }
  }
}

