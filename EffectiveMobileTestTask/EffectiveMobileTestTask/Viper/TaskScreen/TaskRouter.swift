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
}

final class TaskRouter: TaskRouterInput {

    weak var viewController: UIViewController?
    
    func openDetailScreen(with task: Task) {
        viewController?.navigationController?.pushViewController(DetaillViewController(task: task), animated: true)
    }
    
    func openDetailScreen() {
        viewController?.navigationController?.pushViewController(DetaillViewController(), animated: true)
    }

    func presentAlert(_ text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
