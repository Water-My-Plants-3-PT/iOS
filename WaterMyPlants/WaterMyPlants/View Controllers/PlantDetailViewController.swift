//
//  PlantDetailViewController.swift
//  WaterMyPlants
//
//  Created by Bronson Mullens on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    // let plantController = PlantController

    let pickerData = [
        ["1", "2", "3", "4", "5", "6", "7"],
        ["Days", "Weeks"]
    ]


    
    let dateAdded = Date()
    
    // MARK: - IBOutlets
    
    // Used to fetch the frequency of watering
    @IBOutlet weak var lastWateredPicker: UIDatePicker!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var waterFrequencyPicker: UIPickerView!

    @IBOutlet weak var plantImage: UIImageView!


    @IBOutlet weak var plantNameTextField: UITextField!


    // MARK: - IBActions

    override func viewDidLoad() {
        super.viewDidLoad()
       waterFrequencyPicker.delegate = self
        waterFrequencyPicker.dataSource = self
    }
    
    // MARK: - Methods

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
    func frequencyPickerChanged(frequencyPicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        /*
         Should be able to grab whatever date is on the picker and
         convert it to a string to be stored in the label's text.
         Might be useful to also store the date to be used in a calculation
         to determine a future watering date.
         */
        
    }

}
