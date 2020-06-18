//
//  PlantCollectionViewCell.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit

// Subclass UICollectionViewCell for our customizations
class PlantCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var plantName: UILabel!
    func configure(name: String) {
        plantName.text = name
    }
}
