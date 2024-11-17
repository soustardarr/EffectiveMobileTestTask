//
//  TaskEntity+CoreDataProperties.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var title: String
    @NSManaged public var uuid: UUID
    @NSManaged public var descriptionText: String
    @NSManaged public var date: String?
    @NSManaged public var completed: Bool

}

extension TaskEntity : Identifiable {

}

extension TaskEntity {

    convenience init(from task: Task, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = task.id as? NSNumber
        self.uuid = task.uuid
        self.title = task.title
        self.descriptionText = task.descriptionText
        self.date = task.date
        self.completed = task.completed
    }
}
