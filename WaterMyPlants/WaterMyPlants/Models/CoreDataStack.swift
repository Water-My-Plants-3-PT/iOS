//
//  CoreDataStack.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    lazy var container: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "WaterMyPlants")
      container.loadPersistentStores { _, error in
         if let error = error {
            fatalError("Failed to load persistent stores: \(error)")
         }
      }
      container.viewContext.automaticallyMergesChangesFromParent = true
      return container
    }()

    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
      var error: Error?
      context.performAndWait {
         do {
            try context.save()
         } catch let saveError as NSError {
            error = saveError
         }
      }
      if let error = error {
         throw error
      }
    }
    var mainContext: NSManagedObjectContext {
       container.viewContext
    }
}
