//
//  ViewController.swift
//  WaterMyPlants
//
//  Created by conner on 6/16/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let plantController = PlantController()

    // Creates an alert which will get the plant name from user
    @objc func addButtonTapped() {
        // Get plant name from textfield
        let alertController = UIAlertController(title: "Add Plant", message: "Enter the plant name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Name:"
        }
        // Still need to add support for watering interval (hours) from AC
        let submit = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { _ -> Void in
            let nameInput = alertController.textFields![0] as UITextField
            if nameInput.text != nil {
                guard let name = nameInput.text else { return }
                if name.isEmpty { return }
                // Save it to coredata, send it to Server
                let plant = Plant(name: name, lastWatered: Date(), nextWatering: Date())
                do {
                    try CoreDataStack.shared.mainContext.save()
                    self.plantController.sendPlantToServer(plant)
                    // Notify observers that new plant has been added
                    NotificationCenter.default.post(name: .newPlantAdded, object: self)
                } catch {
                    NSLog("Error saving managed object context: \(error)")
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alertController.addAction(submit)
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Title
        self.title = "Water my Plants"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Add Button -> runs addButtonTapped()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
}
