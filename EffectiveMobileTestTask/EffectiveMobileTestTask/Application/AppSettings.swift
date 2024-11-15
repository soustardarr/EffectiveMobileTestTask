//
//  AppSettings.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 14.11.2024.
//

import Foundation
import UIKit

final class AppSettings {
    func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .yellow
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}
