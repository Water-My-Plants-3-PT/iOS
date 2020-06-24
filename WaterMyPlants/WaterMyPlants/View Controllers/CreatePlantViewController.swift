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

    var nextWater: Date?
    var plantController: PlantController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var lastWateredPicker: UIDatePicker!

    @IBOutlet weak var frequencyTextField: UITextField!

    @IBOutlet weak var nextWaterLabel: UILabel!

    @IBOutlet weak var plantImage: UIImageView!

    @IBOutlet weak var plantNameTextField: UITextField!
    
    @IBOutlet weak var maintenanceControl: UISegmentedControl!
    
    // MARK: - Methods
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)

    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = plantNameTextField.text,
            let lastWatered = lastWateredPicker?.date,
            let frequencyString = frequencyTextField.text,
            let frequency = Int(frequencyString) else {
                print("ERROR AHH")
                let alertController = UIAlertController()
                // TODO: Notify user to fill out fields
                
                return
        }
        
        // let maintenanceLevel = maintenanceControl.selectedSegmentIndex
        
        // Change to the proper initializer
        let newPlant = Plant(name: name, lastWatered: lastWatered, frequency: frequency)
        
        plantController?.sendPlantToServer(newPlant)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}
