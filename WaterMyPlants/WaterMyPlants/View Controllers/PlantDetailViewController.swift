//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Bronson Mullens on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit
import CoreData

class PlantDetailViewController: UIViewController {
    
    // MARK: - Properties

    let plantController = PlantController()
    var plant: Plant?
    var wasEdited: Bool = false
    let dateAdded = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let plant = plant else { return }
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        lastWateredPicker.datePickerMode = .dateAndTime
        lastWateredPicker.maximumDate = Date()
        lastWateredPicker.date = plant.lastWatered!
        
        nextWaterLabel.text = "Next Watering: " + dateFormatter.string(from: plant.nextWatering!)
        
        plantNameTextField.text = plant.name!
    }

    // MARK: - IBOutlets

    @IBOutlet weak var lastWateredPicker: UIDatePicker!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var nextWaterLabel: UILabel!
    @IBOutlet weak var plantNameTextField: UITextField!
    
    // MARK: - IBActions

    override func setEditing(_ editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        if editing {
            wasEdited = true
        }
        plantNameTextField.isUserInteractionEnabled = editing
        lastWateredPicker.isUserInteractionEnabled = editing
        frequencyTextField.isUserInteractionEnabled = editing
        navigationItem.hidesBackButton = editing
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let name = plantNameTextField.text, !name.isEmpty,
            let frequency = frequencyTextField.text, !frequency.isEmpty,
            let days = Int(frequency),
                let plant = plant
                else { return }

            let frequencyInSeconds = TimeInterval(((days*24)*60)*60)

            plant.name = name
            plant.nextWatering = Date(timeInterval: frequencyInSeconds, since: lastWateredPicker.date)
            plant.lastWatered = lastWateredPicker.date
            plantController.sendPlantToServer(plant)

            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        // Unwrap optionals
        guard let text = frequencyTextField.text, !text.isEmpty, let days = Int(text), days > 0 else { nextWaterLabel.text = "Next Watering:"; return }
        // Get frequency
        let frequencyInSeconds = TimeInterval(((days*24)*60)*60)
        // Change label for next watering
        nextWaterLabel.text = "Next Watering: " + dateFormatter.string(from: lastWateredPicker.date + frequencyInSeconds)
    }
    
    @IBAction func frequencyChanged(_ sender: UITextField) {
        print("Frequency changed")
        // Unwrap optionals
        guard let text = frequencyTextField.text, !text.isEmpty, let days = Int(text), days > 0 else { nextWaterLabel.text = "Next Watering:"; return }

        // Cant choose to get a notification for the past
        let frequencyInSeconds = TimeInterval(((days*24)*60)*60)
        lastWateredPicker.minimumDate = (plant?.nextWatering)! - frequencyInSeconds
        
        // Change label for next watering
        nextWaterLabel.text = "Next Watering: " + dateFormatter.string(from: lastWateredPicker.date + frequencyInSeconds)
    }
    
    @IBAction func hasBeenWatered(_ sender: UIButton) {
        guard let plant = plant else { return }
        plant.nextWatering = Date(timeIntervalSinceNow: plant.nextWatering!.timeIntervalSinceReferenceDate - plant.lastWatered!.timeIntervalSinceReferenceDate)
        nextWaterLabel.text = "Next Watering: " + dateFormatter.string(from: plant.nextWatering!)
    }
}
