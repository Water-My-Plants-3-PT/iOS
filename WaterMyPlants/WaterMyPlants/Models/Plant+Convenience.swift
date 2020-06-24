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

// NOTE: imageData is of type Data, both in coredata and in here - to derive and image, unwrap data and use UIImage(data: ${YOURPLANT}.imageData)

extension Plant {
    // Initialize a new Plant
    @discardableResult convenience init(name: String, identifier: String = UUID().uuidString, lastWatered: Date, frequency: Int, nextWatering: Date = Date(), imageData: Data? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.identifier = identifier
        self.lastWatered = lastWatered
        self.frequency = Int16(frequency)
        self.nextWatering = nextWatering
        self.imageData = imageData
   }

    // Initialize a new Plant from a PlantRepresentation
    @discardableResult convenience init(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(name: plantRepresentation.name,
                  identifier: plantRepresentation.identifier,
                  lastWatered: plantRepresentation.lastWatered,
                  frequency: plantRepresentation.frequency,
                  nextWatering: plantRepresentation.nextWatering,
                  imageData: plantRepresentation.imageData,
                  context: context)
    }

    // Reference Plant -> PlantRepresentation
    var plantRepresentation: PlantRepresentation? {
        guard let name = name,
            let identifier = identifier,
            let lastWatered = lastWatered,
            let nextWatering = nextWatering else { return nil }
        return PlantRepresentation(name: name, identifier: identifier, lastWatered: lastWatered, nextWatering: nextWatering, imageData: imageData, frequency: Int(frequency))
    }
}
