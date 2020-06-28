//
//  PlantNotifications.swift
//  WaterMyPlants
//
//  Created by conner on 6/24/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation
import UserNotifications

/*
 Wrapper functions for scheduling/cancelling a notification for a plant to be watered
 */

func schedulePlantNotification(_ plant: Plant) {
    // Unwrap optionals
    guard let name = plant.name,
        let plantuuid = plant.identifier,
        let nextWatering = plant.nextWatering else { return }
    // Request user's permission to send notifications
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        guard error == nil, granted == true else {
            print("Error requesting notification authorization OR user didn't grant access")
            return
        }
    }

    // Set the notification content
    let content = UNMutableNotificationContent()
    content.title = "Plant Parenthood"
    content.body = "Time to water \(name)!"

    // Date in which to send the notification
    //let demoDate = Date().addingTimeInterval(6)
    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextWatering)

    // Set the trigger, make the request
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: plantuuid, content: content, trigger: trigger)
    
    // Add it to the notification center
    center.add(request) { (error) in
        guard error == nil else { print("Error adding request to NotificationCenter"); return }
    }
}

func cancelPlantNotification(_ plant: Plant) {
    guard let plantuuid = plant.identifier else { return }
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [plantuuid])
}
