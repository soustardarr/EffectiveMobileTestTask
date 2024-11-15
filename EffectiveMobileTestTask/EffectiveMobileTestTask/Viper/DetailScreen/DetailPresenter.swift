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
    func popViewController(with task: Task) {
        router.popViewController(with: task)
    }
    
    func saveTask(_ task: Task) {
        // interactor save to db
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func didReciveError(_ error: String) {
        //router alert
    }
}

