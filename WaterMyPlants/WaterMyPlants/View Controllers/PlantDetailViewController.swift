//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Bronson Mullens on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit

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


    // MARK: - IBActions

    @IBAction func lastWaterPickerChanged(_ sender: Any) {


    func frequencyPickerChanged(frequencyPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        }
        /*
         Should be able to grab whatever date is on the picker add the frequency entered by user, and
         convert it to a string to be stored in the label's text.
         Might be useful to also store the date to be used in a calculation
         to determine a future watering date.
         */

    }

    
    // MARK: - Methods



    override func setEditing(_ editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        if editing{
            wasEdited = true
        }
        plantNameTextField.isUserInteractionEnabled = isEditing
        navigationItem.hidesBackButton = editing
    }

    override func viewWillDisappear(_ animated: Bool) {     // need to add frequency TF edit capability and update waterLabel
        super.viewWillDisappear(animated)
        if wasEdited{
            guard let name = plantNameTextField.text, !name.isEmpty,
                let plant = plant
                else { return }

            plant.name = name
            plantController?.sendPlantToServer(plant)

            do{
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }


    private func updateViews() {
        plantNameTextField.text = plant?.name
        plantNameTextField.isUserInteractionEnabled = isEditing
               //need to fix this Label to link to the function for setting date
              //nextWaterLabel.text = plant?.nextWatering
              frequencyTextField.isUserInteractionEnabled = isEditing

    }


}
