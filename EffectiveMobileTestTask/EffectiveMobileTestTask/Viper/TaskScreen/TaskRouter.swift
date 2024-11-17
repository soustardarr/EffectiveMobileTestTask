//
//  TaskRouter.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import Foundation
import UIKit

protocol TaskRouterInput {
    func openDetailScreen(with task: Task)
    func openDetailScreen()
    func presentAlert(_ text: String)
    func presentActivityViewController(_ task: Task)
}

final class TaskRouter: TaskRouterInput {

    weak var viewController: UIViewController?
    weak var presenter: TaskPresenter?

    func openDetailScreen(with task: Task) {
        let detailVC = DetailAssembly.assemble(with: task, output: presenter)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func openDetailScreen() {
        let detailVC = DetailAssembly.assemble(output: presenter)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }

    func presentAlert(_ text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }

    func presentActivityViewController(_ task: Task) {
        let activity = UIActivityViewController(
            activityItems: [ task.title, task.date ?? "", task.descriptionText ],
            applicationActivities: []
        )
        viewController?.present(activity, animated: true)
    }
}
