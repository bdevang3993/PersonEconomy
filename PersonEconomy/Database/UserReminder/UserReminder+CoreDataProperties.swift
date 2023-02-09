//
//  UserReminder+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 01/12/21.
//
//

import Foundation
import CoreData


extension UserReminder {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserReminder> {
        return NSFetchRequest<UserReminder>(entityName: "UserReminder")
    }

    @NSManaged public var userReminderId: Int64
    @NSManaged public var reminderName: String?
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var eventType: String?
    @NSManaged public var setType: String?
    @NSManaged public var amount: String?

}
