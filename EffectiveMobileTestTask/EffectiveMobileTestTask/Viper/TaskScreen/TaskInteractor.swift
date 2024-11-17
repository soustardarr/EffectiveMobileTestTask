//
//  TaskInteractor.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import Foundation

protocol TaskInteractorInput: AnyObject {
    var output: TaskInteractorOutput? { get set }
    func obtainTasks()
    func deleteTask(_ task: Task)
    func updateTask(_ task: Task)
}

protocol TaskInteractorOutput: AnyObject {
    func didReciveError(_ error: String)
    func didReciveTasks(_ tasks: [Task])
}


final class TaskInteractor: TaskInteractorInput {
    
    var output: TaskInteractorOutput?
    private var networkService: NetworkServiceProtocol
    private var coreDataService: CoreDataServiceProtocol

    init(
        networkService: NetworkServiceProtocol = ServiceLocator.shared.resolve(),
        coreDataService: CoreDataServiceProtocol = ServiceLocator.shared.resolve()
    ) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }

    func obtainTasks() {
        coreDataService.fetchTasks { [weak self ] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                print(" data from core data ")
                output?.didReciveTasks(tasks)

            case .failure(let error):
                print(error)
                print("data from request")
                obtainRequest()
            }
        }
    }

    private func obtainRequest() {
        networkService.fetchData { [ weak self ] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                output?.didReciveTasks(tasks)
                saveTaskToDb(tasks)

            case .failure(let error):
                output?.didReciveError(error.localizedDescription)
                print(error)
            }
        }
    }

    private func saveTaskToDb(_ tasks: [Task]) {
        coreDataService.saveTasks(tasks) { result in
            switch result {
            case .success:
                print("успешное сохранение в базу данных")

            case .failure(let error):
                print("ошибка сохранения в базу данных \(error)")
            }
        }
    }

    func deleteTask(_ task: Task) {
        coreDataService.deleteTask(task) { result in
            switch result {
            case .success:
                print("успешное удваление из бд")

            case .failure(let error):
                print("произошла ошибка удаления из бд \(error)")
            }
        }
    }

    func updateTask(_ task: Task) {
        coreDataService.updateTask(task, uuid: task.uuid) { result in
            switch result {
            case .success:
                print("успешное изменения таски в бд")
            case .failure(let error):
                print("произошла ошибка изменения таски в бд \(error)")
            }
        }
    }
}
