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



    // MARK: - Methods



    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)

    }
/*    NEED TO FIX THIS SECTION




    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let plantName = plantNameTextField.text, !plantName.isEmpty,
              let last = lastWateredPicker.date
                  delegateLast?.lastWateredWasPicked(date: last),
        let next = waterFrequencyPicker.
            else  { return }



        let plant = Plant(name: plantName, identifier: UUID().uuidString, lastWatered: last, nextWatering: nextWatering, context: CoreDataStack.shared.mainContext)

        plantController?.sendPlantToServer(plant: plant)

        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Error saving managed object context: \(error)")
            
        }

    }   */
}
