//
//  Constants.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation
import UIKit

// selected api which can be changed by tapping on the settings icon in the main table view
var selectedAPI = firebaseURL

// Main web API endpoints
let webapiURL = URL(string: "https://water-my-plants-6-2020.herokuapp.com/api/")!
let register = "auth/register"
let login = "auth/login"
let plants = "plants"
// Used as backup if web API fails
let firebaseURL = URL(string: "https://watermyplants-8a654.firebaseio.com/")!
// For our UITableViewCell(s)
let reuseIdentifier = "PlantCell"
// Number of Background Images in .xcassets named "CellBackgroundNUMBER.png"
let numberOfBackgroundImages = 9
// Load pngs -> UIImage array for use in PlantTableViewCell::configureCell()
var defaultCellBackgroundImages: [UIImage] {
    var loadedImages: [UIImage] = []
    for index in 0...numberOfBackgroundImages {
        if let defaultBackground = UIImage(named: "CellBackground" + String(index) + ".png") {
            loadedImages.append(defaultBackground)
        }
    }
    return loadedImages
}
