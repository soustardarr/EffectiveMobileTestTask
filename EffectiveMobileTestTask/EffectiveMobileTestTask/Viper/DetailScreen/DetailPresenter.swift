//
//  DetailPresenter.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation

protocol DetailPresenterInput: AnyObject {
    var output: DetailPresenterOutput? { get set }
}

protocol DetailPresenterOutput: AnyObject {

}


final class DetailPresenter: DetailPresenterInput {
    // MARK: - stored prop
    weak var output: DetailPresenterOutput?

    private let interactor: DetailInteractorInput
    private let router: DetailRouterInput
    private let view: DetailViewInput

    // MARK: - init
    init(
        interactor: DetailInteractorInput,
        router: DetailRouterInput,
        view: DetailViewInput
    ) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}


extension DetailPresenter: DetailViewOutput {
    func presentAlert(with title: String, message: String) {
        router.presentAlert(title, message)
    }
    
    func updateTask(_ task: Task, uuid: UUID) {
        interactor.updateTask(task, uuid: uuid)
    }
    
    func popViewController(with task: Task, oldUUID: UUID) {
        router.popViewController(with: task, oldUUID: oldUUID)
    }
    
    func saveTask(_ task: Task) {
        interactor.addTask(task)
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func didReciveError(_ error: String) {
        router.presentAlert("ошибка", error)
    }
}

