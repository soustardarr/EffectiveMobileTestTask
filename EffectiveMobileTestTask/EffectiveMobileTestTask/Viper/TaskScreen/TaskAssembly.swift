//
//  TaskAssembly.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import Foundation
import UIKit

final class TaskAssembly {
    static func assemble() -> UIViewController {
        let view = TaskViewController()
        let interactor = TaskInteractor()
        let router = TaskRouter()
        let presenter = TaskPresenter(interactor: interactor, router: router, view: view)

        interactor.output = presenter
        view.output = presenter
        router.viewController = view
        return view
    }
}
