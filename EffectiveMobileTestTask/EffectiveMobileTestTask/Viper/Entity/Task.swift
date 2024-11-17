//
//  Task.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import Foundation


struct Task: Decodable {
    var id: Int?
    var uuid = UUID()
    let title: String
    let descriptionText: String
    let date: String?
    var completed: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case todo
        case completed
        case date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        let todo = try container.decode(String.self, forKey: .todo)
        title = todo
        descriptionText = todo
        completed = try container.decode(Bool.self, forKey: .completed)

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            date = formatter.string(from: yesterday)
        } else {
            date = formatter.string(from: Date())
        }
    }

    init(id: Int? = nil, uuid: UUID, title: String, descriptionText: String, date: String, completed: Bool) {
        self.id = id
        self.uuid = uuid
        self.title = title
        self.descriptionText = descriptionText
        self.date = date
        self.completed = completed
    }
}


struct TodoResponse: Decodable {
    let todos: [Task]
}
