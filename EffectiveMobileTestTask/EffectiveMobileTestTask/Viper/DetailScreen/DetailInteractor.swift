//
//  DetailInteractor.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation

protocol DetailInteractorInput: AnyObject {
    var output: DetailInteractorOutput? { get set }
    func deleteTask(_ task: Task)
}

protocol DetailInteractorOutput: AnyObject {
    func didReciveError(_ error: String)
}


final class DetailInteractor: DetailInteractorInput {

    var output: DetailInteractorOutput?

    func deleteTask(_ task: Task) {
        // запрос в бд
    }
}
