//
//  Plant+Convenience.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//
import Foundation
import UIKit
import CoreData

/*
    Plant object initializers
*/

extension Plant {
    // Initialize a new Plant
    @discardableResult convenience init(name: String, identifier: String = UUID().uuidString, lastWatered: Date, nextWatering: Date, imageData: Data? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.identifier = identifier
        self.lastWatered = lastWatered
        self.nextWatering = nextWatering
        self.imageData = imageData
   }

    // Initialize a new Plant from a PlantRepresentation
    @discardableResult convenience init(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(name: plantRepresentation.name,
                  identifier: plantRepresentation.identifier,
                  lastWatered: plantRepresentation.lastWatered,
                  nextWatering: plantRepresentation.nextWatering,
                  imageData: plantRepresentation.imageData,
                  context: context)
    }

    // Reference Plant.plantRepresentation to get it's PlantRepresentation form
    var plantRepresentation: PlantRepresentation? {
        guard let name = name,
            let identifier = identifier,
            let lastWatered = lastWatered,
            let nextWatering = nextWatering else { return nil }
        return PlantRepresentation(name: name, identifier: identifier, lastWatered: lastWatered, nextWatering: nextWatering, imageData: imageData)
    }
}
