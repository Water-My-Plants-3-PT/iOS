//
//  PlantRepresentation.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation

struct PlantRepresentation: Codable {
    let name: String
    let identifier: String
    let lastWatered: Date
    let nextWatering: Date
    let imageData: Data?
}
