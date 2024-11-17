//
//  DetailRouter.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation
import UIKit

protocol DetailRouterInput {
    var output: DetailRouterOutput? { get set }
    func popViewController(with task: Task, oldUUID: UUID)
    func presentAlert(_ title: String, _ text: String)
}

protocol DetailRouterOutput: AnyObject {
    func addTask(with task: Task, oldUUID: UUID)
}

final class DetailRouter: DetailRouterInput {
    weak var output: DetailRouterOutput?
    weak var viewController: UIViewController?

    func popViewController(with task: Task, oldUUID: UUID) {
        output?.addTask(with: task, oldUUID: oldUUID)
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func presentAlert(_ title: String, _ text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

