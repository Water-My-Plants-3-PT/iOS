//
//  PlantsCollectionViewController.swift
//  WaterMyPlants
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit
import CoreData

class PlantsCollectionViewController: UICollectionViewController {
     // Fetch an array of Plant objects, sorted by nextWatering
    private var plants: [Plant] {
       let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nextWatering", ascending: true)]
       let ctx = CoreDataStack.shared.mainContext
       do {
          return try ctx.fetch(fetchRequest)
       } catch {
          NSLog("Error fetching entries: \(error)")
          return []
       }
    }
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
       let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nextWatering", ascending: false)]
       let frc = NSFetchedResultsController(
          fetchRequest: fetchRequest,
          managedObjectContext: CoreDataStack.shared.mainContext,
          sectionNameKeyPath: nil,
          cacheName: nil)
        frc.delegate = self as? NSFetchedResultsControllerDelegate
       do {
          try frc.performFetch()
       } catch {
          print(error)
       }
       return frc
    }()
    
    private func debugInfo(_ plant: Plant) {
        NSLog("You tapped on \(plant.name!)")
        NSLog("DEBUG INFO:")
        NSLog("\tname: \(plant.name!)")
        NSLog("\tidentifier: \(plant.identifier!.uuidString)")
        NSLog("\tlastWatered: \(plant.lastWatered!)")
        NSLog("\tnextWatering: \(plant.nextWatering!)")
        NSLog("\n")
    }
    
    @objc func updateViews() {
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Observer to updateViews() on newPlantAdded
        NotificationCenter.default.addObserver(self,
           selector: #selector(updateViews),
           name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
           object: CoreDataStack.shared.mainContext)
    }

    // MARK: UICollectionViewDataSource

    // Number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }

    // Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let plantCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlantCollectionViewCell {
            plantCell.configure(name: plants[indexPath.row].name!)
            cell = plantCell
        }
        return cell
    }
    
    // Run when user taps a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugInfo(plants[indexPath.row])
    }
}
