//
//  ServiceLocator.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation

final class ServiceLocator {

    private var services: [String: Any] = [:]

    static let shared = ServiceLocator()
    private init() {}

    func register<T>(_ service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let service = services[key] as? T else {
            fatalError("Service \(key) not registered")
        }
        return service
    }
}
