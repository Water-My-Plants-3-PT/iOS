//
//
//  PlantsTableViewController.swift
//  uiTest
//
//  Created by conner on 6/21/20.
//  Copyright © 2020 conner. All rights reserved.
//

import UIKit
import CoreData

class PlantsTableViewController: UITableViewController {

    let plantController = PlantController()

    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "nextWatering", ascending: true)
        ]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: "nextWatering",
                                             cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()

    private func configureViews() {
        self.title = "Water My Plants"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    // Subclass cell -> configure
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }

        cell.plant = fetchedResultsController.object(at: indexPath)

        return cell
    }

    // Set Cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = CoreDataStack.shared.mainContext
            let plant = fetchedResultsController.object(at: indexPath)
            context.delete(plant)
            plantController.deletePlantFromServer(plant)
            do {
                try context.save()
            } catch {
                NSLog("Error deleting plant: \(error)")
            }
        }
    }

    // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 if segue.identifier == "ShowDetailSegue" {
                     if let detailVC = segue.destination as? PlantDetailViewController,
                         let indexPath = tableView.indexPathForSelectedRow {
                         detailVC.plant = fetchedResultsController.object(at: indexPath)

                     } else if segue.identifier == "CreatePlantModalSegue" {
                         if let naviC = segue.destination as? UINavigationController,
                            let createPlant = naviC.viewControllers.first as? CreatePlantViewController {
                             createPlant.plantController = plantController
                         }

                     }
                 }
             }


}

extension PlantsTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

