//
//  Task.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import Foundation


struct Task {
    var id: Int?
    let uuid = UUID()
    let title: String
    let description: String
    let date: String
    var isCompleted: Bool
}
