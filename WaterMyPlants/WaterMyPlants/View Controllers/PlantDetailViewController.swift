//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Bronson Mullens on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties

    var plantController: PlantController?
    var plant: Plant?
    var wasEdited: Bool = false
    let dateAdded = Date()

    let pickerData = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["Days", "Weeks"]
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        waterFrequencyPicker.delegate = self
        waterFrequencyPicker.dataSource = self
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }


    // MARK: - IBOutlets

    @IBOutlet weak var lastWateredPicker: UIDatePicker!

    @IBOutlet weak var waterFrequencyPicker: UIPickerView!

    @IBOutlet weak var plantImage: UIImageView!

    @IBOutlet weak var plantNameTextField: UITextField!


    // MARK: - IBActions
    func frequencyPickerChanged(frequencyPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()

        /*
         Should be able to grab whatever date is on the picker and
         convert it to a string to be stored in the label's text.
         Might be useful to also store the date to be used in a calculation
         to determine a future watering date.
         */

    }

    
    // MARK: - Methods

    // Set up custom pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int
    ) -> Int {
        return pickerData[component].count
    }

    func pickerView(_
        pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
    ) -> String? {
        return pickerData[component][row]
    }


    override func setEditing(_ editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        if editing{
            wasEdited = true
        }
        plantNameTextField.isUserInteractionEnabled = isEditing
        navigationItem.hidesBackButton = editing
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited{
            guard let name = plantNameTextField.text, !name.isEmpty,
                let plant = plant
                else { return }

            plant.name = name
            plantController?.sendPlantToServer(plant: plant)

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

        // add image and picker info

    }


}
