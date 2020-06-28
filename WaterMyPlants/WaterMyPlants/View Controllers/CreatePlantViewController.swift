//
//  CreatePlantViewController.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//

/*
    Create a new plant and add it to coredata, send to api/fb
*/

import UIKit
import CoreData
class CreatePlantViewController: UIViewController {
    let plantController = PlantController()

    // MARK: - IBOutlets
    @IBOutlet weak var lastWateredPicker: UIDatePicker!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var nextWaterLabel: UILabel!
    @IBOutlet weak var plantNameTextField: UITextField!
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastWateredPicker.datePickerMode = .dateAndTime
        lastWateredPicker.maximumDate = Date()
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
        // Unwrap optionals
        guard let text = frequencyTextField.text, !text.isEmpty, let days = Int(text), days > 0 else { nextWaterLabel.text = "Next Watering:"; return }

        // Cant choose to get a notification for the past
        let frequencyInSeconds = TimeInterval(((days*24)*60)*60)
        lastWateredPicker.minimumDate = lastWateredPicker.date - frequencyInSeconds
        
        // Change label for next watering
        nextWaterLabel.text = "Next Watering: " + dateFormatter.string(from: lastWateredPicker.date + frequencyInSeconds)
    }
    
    // MARK: - Methods
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        // Unwrap optionals
        guard let name = plantNameTextField.text,
            !name.isEmpty,
            let frequencyString = frequencyTextField.text,
            let days = Int(frequencyString) else {
                // Something is nil, try again
                let alertController = UIAlertController(title: "Warning",
                                                    message: "Make sure you've filled out all input fields.",
                                                    preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        // Initialize a date for the nextWatering from frequency
        let frequencyInSeconds = TimeInterval(((days*24)*60)*60)
        // Create plant
        let newPlant = Plant(
            name: name,
            lastWatered: lastWateredPicker.date,
            nextWatering: Date(timeInterval: frequencyInSeconds, since: lastWateredPicker.date))
        do {
            // Save it to coredata
            try CoreDataStack.shared.mainContext.save()
            // Send it to fb
            self.plantController.sendPlantToServer(newPlant)
            // Schedule plant local notification for the next watering
            schedulePlantNotification(newPlant)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
