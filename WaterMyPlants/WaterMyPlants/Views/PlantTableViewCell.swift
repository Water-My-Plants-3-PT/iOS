//
//  PlantTableViewCell.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/22/20.
//  Copyright © 2020 conner. All rights reserved.
//
import UIKit

/*
    Calls configureCell() once plant is set on segue
    configureCell() sets the cells information, including a random background if plant image data is nil
*/

class PlantTableViewCell: UITableViewCell {
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var nextWateringLabel: UILabel!
    
    var plant: Plant? {
        didSet {
            configureCell()
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }

    func configureCell() {
        // Unwrap optionals
        guard let name = plant?.name,
            let nextWatering = plant?.nextWatering else { return }

        // Set Cell info
        plantNameLabel.text = name
        nextWateringLabel.text = "Next watering  " + dateFormatter.string(from: nextWatering)
        
        // If imageData is not nil, set the background to the image provided in plant object
        if let imageData = plant?.imageData {
            // Image provided
            self.backgroundColor = UIColor(patternImage: UIImage(data: imageData)!)
        } else {
            // Image is nil, fallback to random default from assets.xcassets
            let imagesCount = defaultCellBackgroundImages.count
            if imagesCount > 0 {
                self.backgroundColor = UIColor(patternImage: defaultCellBackgroundImages[Int.random(in: 0...imagesCount-1)])
            }
        }
    }
}
