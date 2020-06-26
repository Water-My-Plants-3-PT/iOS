//
//  CreatePlantViewController.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit
import CoreData
class CreatePlantViewController: UIViewController {
    // MARK: - Properties
    let plantController = PlantController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBOutlets
    @IBOutlet weak var lastWateredPicker: UIDatePicker!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var nextWaterLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var prioritySelector: UISegmentedControl!
    
    // MARK: - Methods
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {

        guard let name = plantNameTextField.text,
            let frequencyString = frequencyTextField.text,
            let days = Int(frequencyString) else {
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
        // timeInterval() from frequency in hours
        let frequencyInSeconds = TimeInterval(((days*24)*60)*60)
        // create plant, save to coredata, send to firebase
        let newPlant = Plant(
            name: name,
            lastWatered: lastWateredPicker.date,
            nextWatering: Date(timeInterval: frequencyInSeconds, since: lastWateredPicker.date),
            maintenanceLevel: Priority(rawValue: Int16(prioritySelector!.selectedSegmentIndex))!)

        do {
            try CoreDataStack.shared.mainContext.save()
            self.plantController.sendPlantToServer(newPlant)
            // Notify observers that new plant has been added
            NotificationCenter.default.post(name: .newPlantAdded, object: self)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }

        navigationController?.dismiss(animated: true, completion: nil)
    }

}
