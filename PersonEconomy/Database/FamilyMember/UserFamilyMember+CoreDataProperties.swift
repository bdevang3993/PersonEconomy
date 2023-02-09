//
//  UserFamilyMember+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 11/01/21.
//
//

import Foundation
import CoreData


extension UserFamilyMember {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserFamilyMember> {
        return NSFetchRequest<UserFamilyMember>(entityName: "UserFamilyMember")
    }
    @NSManaged public var userid: String?
    @NSManaged public var name: String?
    @NSManaged public var relationShip: String?
    @NSManaged public var occupation: String?
    @NSManaged public var number: String?
}
