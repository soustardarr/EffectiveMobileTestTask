//
//  DetailAssembly.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation
import UIKit

final class DetailAssembly {
    static func assemble(with task: Task? = nil, output: DetailRouterOutput? = nil) -> UIViewController {
        let view = DetailViewController(task: task)
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(interactor: interactor, router: router, view: view)

        interactor.output = presenter
        view.output = presenter
        router.viewController = view
        router.output = output
        return view
    }
}
