//
//  DetailInteractor.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation

protocol DetailInteractorInput: AnyObject {
    var output: DetailInteractorOutput? { get set }
    func addTask(_ task: Task)
    func updateTask(_ task: Task, uuid: UUID)
}

protocol DetailInteractorOutput: AnyObject {
    func didReciveError(_ error: String)
}


final class DetailInteractor: DetailInteractorInput {

    var output: DetailInteractorOutput?

    private var coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol = ServiceLocator.shared.resolve()) {
        self.coreDataService = coreDataService
    }

    func addTask(_ task: Task) {
        coreDataService.addTask(task) { result in
            switch result {
            case .success:
                print(" успешное добавление в бд ")

            case .failure(let error):
                print("ошибка добавления задачи \(error)")
            }
        }
    }

    func updateTask(_ task: Task, uuid: UUID) {
        coreDataService.updateTask(task, uuid: uuid) { result in
            switch result {
            case .success:
                print("успешное изменения таски в бд")
            case .failure(let error):
                print("произошла ошибка изменения таски в бд \(error)")
            }
        }
    }
}
