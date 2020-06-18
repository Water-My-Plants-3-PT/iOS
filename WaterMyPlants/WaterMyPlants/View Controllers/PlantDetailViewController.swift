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
    
    // let plantController = PlantController
    
    let dateAdded = Date()
    
    // MARK: - IBOutlets
    
    // Used to fetch the frequency of watering
    @IBOutlet weak var frequencyPicker: UIDatePicker!
    @IBOutlet weak var frequencyLabel: UILabel!
    
    // MARK: - IBActions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
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
