//
//  PlantTableViewCell.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/22/20.
//  Copyright © 2020 conner. All rights reserved.
//
import UIKit

class PlantTableViewCell: UITableViewCell {
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var nextWateringLabel: UILabel!
    @IBOutlet weak var priorityCircle: UIImageView!
    
    var plant: Plant? {
        didSet {
            configureCell()
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }

    func configureCell() {
        // Unwrap optionals
        guard let name = plant?.name,
            let nextWatering = plant?.nextWatering,
            let maintenanceLevel = plant?.maintenanceLevel else { return }

        // Set Cell info
        plantNameLabel.text = name
        nextWateringLabel.text = "Next watering  " + dateFormatter.string(from: nextWatering)
        switch Priority(rawValue: maintenanceLevel) {
        case .low:
            priorityCircle.tintColor = .green
        case .medium:
            priorityCircle.tintColor = .yellow
        case .high:
            priorityCircle.tintColor = .red
        default:
            break
        }
        if let imageData = plant?.imageData {
            // Image provided
            self.backgroundColor = UIColor(patternImage: UIImage(data: imageData)!)
        } else {
            // Image is nil, fallback to random default
            let imagesCount = defaultCellBackgroundImages.count
            if imagesCount > 0 {
                self.backgroundColor = UIColor(patternImage: defaultCellBackgroundImages[Int.random(in: 0...imagesCount-1)])
            }
        }
    }

}
