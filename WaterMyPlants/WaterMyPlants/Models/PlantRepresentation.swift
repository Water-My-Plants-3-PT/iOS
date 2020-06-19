//
//  PlantRepresentation.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation

struct PlantRepresentation: Codable {
    let name: String
    let identifier: String
    let lastWatered: Date
    let nextWatering: Date
}
