//
//  CoreDataService.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case emptyCoreData
    case taskNotFound
}

protocol CoreDataServiceProtocol {
    func saveContext()
    func saveTasks(_ tasks: [Task], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTask(_ task: Task, uuid: UUID, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CoreDataService: CoreDataServiceProtocol {
    // MARK: - Core Data stack

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EffectiveMobileTestTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveTasks(_ tasks: [Task], completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = self.backgroundContext

        backgroundContext.perform { [ weak viewContext ] in
            tasks.forEach { task in
                let taskEntity = TaskEntity(from: task, context: backgroundContext)
            }
            do {
                try backgroundContext.save()

                viewContext?.perform {
                    do {
                        try viewContext?.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        let viewContext = self.viewContext
        viewContext.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

            let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)

            fetchRequest.sortDescriptors = [dateSortDescriptor, titleSortDescriptor]
            do {
                let taskEntities = try viewContext.fetch(fetchRequest)

                let tasks = taskEntities.map { taskEntity in
                    return Task(
                        id: taskEntity.id as? Int,
                        uuid: taskEntity.uuid,
                        title: taskEntity.title,
                        descriptionText: taskEntity.descriptionText,
                        date: taskEntity.date ?? "",
                        completed: taskEntity.completed
                    )
                }
                if tasks.isEmpty {
                    completion(.failure(CoreDataError.emptyCoreData))
                } else {
                    completion(.success(tasks))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = self.backgroundContext
        backgroundContext.perform { [ weak viewContext ] in
            let taskEntity = TaskEntity(from: task, context: backgroundContext)
            do {
                try backgroundContext.save()

                viewContext?.perform {
                    do {
                        try viewContext?.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func deleteTask(_ task: Task, completion: @escaping (Result<Void, any Error>) -> Void) {
        let backgroundContext = self.backgroundContext
        backgroundContext.perform { [ weak viewContext ] in
            let fetchRequest = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", task.uuid as CVarArg)

            do {
                let taskEntities = try backgroundContext.fetch(fetchRequest)
                if let taskEntityToDelete = taskEntities.first {
                    backgroundContext.delete(taskEntityToDelete)
                    try backgroundContext.save()

                    viewContext?.perform {
                        do {
                            try viewContext?.save()
                            completion(.success(()))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(CoreDataError.taskNotFound))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func updateTask(_ task: Task, uuid: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = self.backgroundContext

        backgroundContext.perform { [weak viewContext] in
            let fetchRequest = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)

            do {
                let taskEntities = try backgroundContext.fetch(fetchRequest)

                if let taskEntityToUpdate = taskEntities.first {
                    taskEntityToUpdate.id = task.id as? NSNumber
                    taskEntityToUpdate.uuid = task.uuid
                    taskEntityToUpdate.title = task.title
                    taskEntityToUpdate.descriptionText = task.descriptionText
                    taskEntityToUpdate.date = task.date
                    taskEntityToUpdate.completed = task.completed

                    try backgroundContext.save()

                    viewContext?.perform {
                        do {
                            try viewContext?.save()
                            completion(.success(()))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(CoreDataError.taskNotFound))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
