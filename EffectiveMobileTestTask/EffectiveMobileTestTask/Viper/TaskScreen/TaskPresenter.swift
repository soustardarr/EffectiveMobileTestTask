//
//  TaskPresenter.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import Foundation

protocol TaskPresenterInput: AnyObject {
    var output: TaskPresenterOutput? { get set }
}

protocol TaskPresenterOutput: AnyObject {

}


final class TaskPresenter: TaskPresenterInput {
    // MARK: - stored prop
    weak var output: TaskPresenterOutput?

    private let interactor: TaskInteractorInput
    private let router: TaskRouterInput
    private let view: TaskViewInput

    // MARK: - init
    init(
        interactor: TaskInteractorInput,
        router: TaskRouterInput,
        view: TaskViewInput
    ) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}


extension TaskPresenter: TaskViewOutput {
    
    func openDetailScreen() {
        router.openDetailScreen()
    }
    
    func openDetailScreen(with task: Task) {
        router.openDetailScreen(with: task)
    }
    
    func deleteTask(with task: Task) {
        interactor.deleteTask(task)
    }
    
    func shareTask(with task: Task) {
        // interactor
    }
    
    func viewDidLoad() {
        interactor.obtainTasks()
    }
}

extension TaskPresenter: TaskInteractorOutput {
    func didReciveError(_ error: String) {
        router.presentAlert(error)
    }
    
    func didReciveTasks(_ tasks: [Task]) {
        view.displayTasks(tasks)
    }
}

extension TaskPresenter: DetailRouterOutput {
    func addTask(with task: Task) {
        view.addTask(task)
    }
}
