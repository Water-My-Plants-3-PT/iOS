//
//  plantController.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/23/20.
//  Copyright © 2020 conner. All rights reserved.
//


import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://water-my-plants-6-2020.herokuapp.com/")!

class PlantController {

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    init() {
        fetchPlantsFromServer()
    }

    // Fetch Plants from firebase
    func fetchPlantsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching plants: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }


            guard let data = data else {
                print("No data returned by data task")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                let plantRepresentations = Array(try JSONDecoder().decode([String : PlantRepresentation].self, from: data).values)

                try self.updatePlants(with: plantRepresentations)
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                print("Error decoding plant representations: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
                return
            }
        }.resume()
    }


    // Send Plant Representation to Firebase!
    func sendPlantToServer(plant: Plant, completion: @escaping CompletionHandler = { _ in }) {

        guard let identifier = plant.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        // https://water-my-plants-6-2020.herokuapp.com//[unique identifier here].json
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard let representation = plant.plantRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding plant \(plant): \(error)")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error PUTting plant to server: \(error)")
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

    // Update/Create Plants with Representations
    private func updatePlants(with representations: [PlantRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        let identifiersToFetch = representations.compactMap({ $0.identifier })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var plantsToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        context.perform {
            do {
                let existingPlants = try context.fetch(fetchRequest)

                for plant in existingPlants {
                    guard let id = plant.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.update(plant: plant, with: representation)
                    plantsToCreate.removeValue(forKey: id)
                }

                for representation in plantsToCreate.values {
                    Plant(plantRepresentation: representation, context: context)
                }
            } catch {
                print("error fetching tasks for identifiers: \(error)")
            }
            do {

                try CoreDataStack.shared.save(context: context)
            } catch {
                print("error saving)")
            }
        }

    }

    private func update(plant: Plant, with representation: PlantRepresentation) {
        plant.name = representation.name
        plant.lastWatered = representation.lastWatered
        plant.nextWatering = representation.nextWatering
    }

    func deletePlantFromServer(_ plant: Plant, completion: @escaping CompletionHandler = { _ in }) {
        guard let identifier = plant.identifier else {
            completion(.failure(.noIdentifier))
            return
        }

        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(.success(true))
        }.resume()
    }
}
