//
//  Constants.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation
import UIKit

var selectedAPI = webapiURL

// Main API
let webapiURL = URL(string: "https://water-my-plants-6-2020.herokuapp.com/")!
let register = "api/auth/register"
let login = "api/auth/login"
// Used as backup if web API fails
let firebaseURL = URL(string: "https://watermyplants-8a654.firebaseio.com/")!
// For our UITableViewCell(s)
let reuseIdentifier = "PlantCell"
// Number of Background Images in .xcassets named "CellBackgroundNUMBER.png"
let numberOfBackgroundImages = 9
// Load pngs -> UIImage array
var defaultCellBackgroundImages: [UIImage] {
    var loadedImages: [UIImage] = []
    for index in 0...numberOfBackgroundImages {
        if let defaultBackground = UIImage(named: "CellBackground" + String(index) + ".png") {
            loadedImages.append(defaultBackground)
        }
    }
    return loadedImages
}
