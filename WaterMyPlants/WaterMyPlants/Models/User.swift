//
//  User.swift
//  WaterMyPlants
//
//  Created by conner on 6/25/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let phoneNumber: String?
}
