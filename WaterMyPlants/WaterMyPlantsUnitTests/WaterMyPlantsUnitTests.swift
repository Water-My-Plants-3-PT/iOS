//
//  WaterMyPlantsUnitTests.swift
//  WaterMyPlantsUnitTests
//
//  Created by conner on 6/28/20.
//  Copyright © 2020 conner. All rights reserved.
//

import XCTest
import CoreData
@testable import WaterMyPlants

class WaterMyPlantsUnitTests: XCTestCase {
    
    var newUsername: String {
        //return "iOS" + String(Int.random(in: 1000...10000))
        return "iOS1982"
    }
    
    func testCreateNewPlant() {
        let newPlant = Plant(name: "Blueberries", lastWatered: Date(), nextWatering: Date())
        XCTAssert(newPlant.name == "Blueberries")
        XCTAssertNotNil(newPlant.identifier)
        XCTAssertNotNil(newPlant.nextWatering)
        XCTAssertNotNil(newPlant.lastWatered)
        XCTAssertNil(newPlant.imageData)
    }
    
    func testConvertPlantToRep() {
        let plant = Plant(name: "Blueberries", lastWatered: Date(), nextWatering: Date())
        let representation = plant.plantRepresentation
        XCTAssertNotNil(representation)
        XCTAssert(representation?.name == "Blueberries")
        XCTAssert(representation?.lastWatered == representation?.nextWatering)
        XCTAssertNil(representation?.imageData)
    }
    
    func testCreateNewUser() {
        let newUser = User(username: "username", password: "password", phoneNumber: nil)
        XCTAssertNotNil(newUser)
        XCTAssertNil(newUser.phoneNumber)
        XCTAssertNotNil(newUser.username)
        XCTAssertNotNil(newUser.password)
    }
    
    func testFetchPlantsFromServer() {
        let plantController = PlantController()
        XCTAssertNotNil(plantController)
        
        let fetchedResultsController: NSFetchedResultsController<Plant> = {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "nextWatering", ascending: true)
            ]
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                 managedObjectContext: CoreDataStack.shared.mainContext,
                                                 sectionNameKeyPath: "nextWatering",
                                                 cacheName: nil)
            frc.delegate = self as? NSFetchedResultsControllerDelegate
            try? frc.performFetch()
            return frc
        }()
        XCTAssertNotNil(fetchedResultsController.object(at: [0]))
    }
    
    func testBackgroundImages() {
        for index in 0...defaultCellBackgroundImages.count-1 {
            XCTAssertNotNil(defaultCellBackgroundImages[index])
        }
    }
    
    func testNewNotification() {
        let newPlant = Plant(name: "Blueberries", identifier: "testid", lastWatered: Date(), nextWatering: Date(timeInterval: 60, since: Date()))
        schedulePlantNotification(newPlant)
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests() { (results) in
            XCTAssert(results.count > 0)
        }
    }
    
    func testCancelNotification() {
        let newPlant = Plant(name: "Blueberries", identifier: "testid", lastWatered: Date(), nextWatering: Date(timeInterval: 60, since: Date()))
        // cancels based on newPlant.identifer
        cancelPlantNotification(newPlant)
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests() { (results) in
            XCTAssertNotNil(results.count)
            cancelPlantNotification(newPlant)
        }
    }
    
    func testSignIn() {
        let plantController = PlantController()
        let testUser = User(username: "conner", password: "conner", phoneNumber: nil)
        plantController.signIn(with: testUser, completion: { error in
            XCTAssertNil(error)
        })
    }
    
    func testSignUp() {
        let plantController = PlantController()
        let newUser = User(username: newUsername, password: "iOSUserTest", phoneNumber: "123-456-7890")
        print("created a new user with name: \(newUser.username)")
        plantController.signUp(with: newUser, completion: { error in
            XCTAssertNil(error)
        })
    }
    
    // Login with created user
    func testSignUp2() {
        let plantController = PlantController()
        let newUser = User(username: newUsername, password: "iOSUserTest", phoneNumber: nil)
        plantController.signIn(with: newUser, completion: { error in
            XCTAssertNil(error)
        })
    }
}
