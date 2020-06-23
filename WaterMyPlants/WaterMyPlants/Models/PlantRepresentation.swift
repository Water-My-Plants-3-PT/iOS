//
//  PlantRepresentation.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//


import Foundation

struct PlantRepresentation: Codable {
    var name: String
    var identifier: String
    var lastWatered: Date
    var nextWatering: Date

}
