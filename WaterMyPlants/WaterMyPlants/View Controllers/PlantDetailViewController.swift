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

    var plantController: PlantController?
    var plant: Plant?
    var wasEdited: Bool = false
    let dateAdded = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }

    // MARK: - IBOutlets

    @IBOutlet weak var lastWateredPicker: UIDatePicker!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var nextWaterLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var prioritySelector: UISegmentedControl!
    
    
    // MARK: - IBActions

 
    override func setEditing(_ editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        if editing {
            wasEdited = true
        }
        plantNameTextField.isUserInteractionEnabled = editing
        prioritySelector.isUserInteractionEnabled = editing
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
            plant.maintenanceLevel = Int16(prioritySelector!.selectedSegmentIndex)

            plantController?.sendPlantToServer(plant)

            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }


    private func updateViews() {
        plantNameTextField.text = plant?.name
        plantNameTextField.isUserInteractionEnabled = isEditing

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let date = formatter.string(from: plant?.nextWatering ?? Date())


       nextWaterLabel.text = date


        let defaultFreq: Int = 1
        frequencyTextField.text = String(defaultFreq)
    }
}
