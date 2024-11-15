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
}

protocol TaskInteractorOutput: AnyObject {
    func didReciveError(_ error: String)
    func didReciveTasks(_ tasks: [Task])
}


final class TaskInteractor: TaskInteractorInput {
    
    var output: TaskInteractorOutput?

    func obtainTasks() {
        // запрос в бд сеть

    }

    func deleteTask(_ task: Task) {
        // запрос в бд 
    }
}
