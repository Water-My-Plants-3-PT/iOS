//
//  plantController.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//
//  Created by conner on 6/17/20.
//  Copyright © 2020 conner. All rights reserved.
//

import Foundation
import CoreData

/*
    Network stuff for sending our plant objects back and forth from firebase / web api
    Also handles signUp() and signIn()
*/

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class PlantController {
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    let loginURL = webapiURL
    let baseURL = firebaseURL
    
    init() {
        fetchPlantsFromServer()
    }
    
    var bearer: Bearer?
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
           let signUpUrl = loginURL.appendingPathComponent(register)
           
           var request = URLRequest(url: signUpUrl)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           do {
               request.httpBody = try JSONEncoder().encode(user)
           } catch {
               print("Error encoding user object: \(error)")
               completion(error)
               return
           }
           
           URLSession.shared.dataTask(with: request) { _, response, error in
               guard error == nil else {
                   completion(error)
                   return
               }
               
               if let response = response as? HTTPURLResponse,
                   response.statusCode != 201 {
                   completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                   return
               }
               
               completion(nil)
           }.resume()
       }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let loginUrl = loginURL.appendingPathComponent(login)
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }

    func sendPlantToServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = plant.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        do {
            guard let plantRepresentation = plant.plantRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(plantRepresentation)
        } catch {
            NSLog("Error encoding \(plant): \(error)")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                NSLog("Error (PUT): \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    func deletePlantFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = plant.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let url = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                NSLog("Error (DELETE): \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }

    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let url = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                NSLog("Error fetching entries from server: \(error!)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let idsAndRepresentations = try JSONDecoder().decode([String: PlantRepresentation].self, from: data)
                let plantRepresentations = idsAndRepresentations.map { $0.value }
                try self.updateEntries(with: plantRepresentations)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                NSLog("Error decoding plant representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }

    func updateEntries(with representations: [PlantRepresentation]) throws {

        let ids = representations.map { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues:
            zip(ids, representations)
        )
        var plantsToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", ids)

        let context = CoreDataStack.shared.mainContext
        do {
            let existingPlants = try context.fetch(fetchRequest)
            for plant in existingPlants {
                guard let identifier = plant.identifier,
                let representation = representationsByID[identifier] else { continue }

                plant.name = representation.name
                plant.identifier = representation.identifier
                plant.lastWatered = representation.lastWatered
                plant.nextWatering = representation.nextWatering

                plantsToCreate.removeValue(forKey: identifier)
            }

            try self.saveToPersistentStore()

            for representation in plantsToCreate.values {
                Plant(plantRepresentation: representation, context: context)
            }

        } catch {
            NSLog("Error fetching plant uuids: \(error)")
        }

        try self.saveToPersistentStore()
    }

    func saveToPersistentStore() throws {
        let context = CoreDataStack.shared.mainContext
        try context.save()
    }
}
