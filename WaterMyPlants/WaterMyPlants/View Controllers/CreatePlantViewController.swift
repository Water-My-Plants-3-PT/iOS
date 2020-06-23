//
//  CreatePlantViewController.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit
import CoreData


protocol LastWateredPickerDelegate {
    func lastWateredWasPicked(date: Date)
}

protocol NextWaterPickerDelegate {
    func nextWaterWasPicked(frequency: Int)   // assuming that this is correct, we need to convert the data from the picker to an Int that we
}

class CreatePlantViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {




    // MARK: - Properties
    var delegateLast: LastWateredPickerDelegate?
    var delegatenext: NextWaterPickerDelegate?
    var plantController: PlantController?
    //var lastWatered: UIDatePicker?
    //var nextWatering: UIPickerView?

    let pickerData = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["Days"]
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        waterFrequencyPicker.delegate = self
        waterFrequencyPicker.dataSource = self

    }


    // MARK: - IBOutlets

    @IBOutlet weak var lastWateredPicker: UIDatePicker!

    @IBOutlet weak var waterFrequencyPicker: UIPickerView!

    @IBOutlet weak var plantImage: UIImageView!

    @IBOutlet weak var plantNameTextField: UITextField!



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

    private func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Need to figure this section out yet
        //
    }

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
