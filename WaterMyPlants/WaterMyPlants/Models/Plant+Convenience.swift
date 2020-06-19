//
//  Plant+Convenience.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    // Initialize a new Plant
    @discardableResult convenience init(name: String, identifier: String = UUID().uuidString, lastWatered: Date = Date(), nextWatering: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    self.init(context: context)
    self.name = name
    self.identifier = identifier
    self.lastWatered = lastWatered
    self.nextWatering = nextWatering
   }
    
    // Initialize a new Plant from a PlantRepresentation
    @discardableResult convenience init(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(name: plantRepresentation.name,
                  identifier: plantRepresentation.identifier,
                  lastWatered: plantRepresentation.lastWatered,
                  nextWatering: plantRepresentation.nextWatering,
                  context: context)
    }
    
    // Reference Plant -> PlantRepresentation
    var plantRepresentation: PlantRepresentation? {
        guard
            let name = name,
            let identifier = identifier,
            let lastWatered = lastWatered,
            let nextWatering = nextWatering else { fatalError("fatalError() in plantRepresentation computed property, Plant+Convenience.swift") }
        return PlantRepresentation(name: name, identifier: identifier, lastWatered: lastWatered, nextWatering: nextWatering)
    }
}
