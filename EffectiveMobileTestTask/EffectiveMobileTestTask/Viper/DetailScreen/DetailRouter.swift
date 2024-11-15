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
    func popViewController(with task: Task)
    func presentAlert(_ text: String)
}

protocol DetailRouterOutput: AnyObject {
    func addTask(with task: Task)
}

final class DetailRouter: DetailRouterInput {
    weak var output: DetailRouterOutput?
    weak var viewController: UIViewController?

    func popViewController(with task: Task) {
        output?.addTask(with: task)
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func presentAlert(_ text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

