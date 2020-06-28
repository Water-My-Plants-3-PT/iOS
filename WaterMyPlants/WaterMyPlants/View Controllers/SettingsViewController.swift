//
//  SettingsViewController.swift
//  WaterMyPlants
//
//  Created by conner on 6/25/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit

/*
    Manual API switcher in case anything goes wrong during the demo
*/

class SettingsViewController: UIViewController {
    @IBOutlet weak var apiSelector: UISegmentedControl!
    override func viewDidLoad() {
        switch selectedAPI {
        case webapiURL:
            apiSelector.selectedSegmentIndex = 0
        case firebaseURL:
            apiSelector.selectedSegmentIndex = 1
        default:
            break
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        switch apiSelector.selectedSegmentIndex {
        case 0:
            selectedAPI = webapiURL
        case 1:
            selectedAPI = firebaseURL
        default:
            break
        }
    }
}
