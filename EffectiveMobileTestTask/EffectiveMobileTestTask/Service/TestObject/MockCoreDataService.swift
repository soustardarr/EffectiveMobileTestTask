//
//  MockCoreDataService.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 17.11.2024.
//

import Foundation
import CoreData

final class MockCoreDataService: CoreDataServiceProtocol {
    var tasksToReturn: [Task] = []
    var errorToReturn: Error?

    func saveContext() {}

    func saveTasks(_ tasks: [Task], completion: @escaping (Result<Void, Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            tasksToReturn.append(contentsOf: tasks)
            completion(.success(()))
        }
    }

    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            completion(.success(tasksToReturn))
        }
    }

    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            tasksToReturn.append(task)
            completion(.success(()))
        }
    }

    func deleteTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            tasksToReturn.removeAll { $0.uuid == task.uuid }
            completion(.success(()))
        }
    }

    func updateTask(_ task: Task, uuid: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            if let index = tasksToReturn.firstIndex(where: { $0.uuid == uuid }) {
                tasksToReturn[index] = task
                completion(.success(()))
            } else {
                completion(.failure(CoreDataError.taskNotFound))
            }
        }
    }
}
