//
//  UserProfile+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 09/01/21.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var name: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var emailId: String?
    @NSManaged public var password: String?
    @NSManaged public var birthDay: String?
    @NSManaged public var gender: String?

}
