//
//  UserLICDetail+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 22/02/21.
//
//

import Foundation
import CoreData


extension UserLICDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLICDetail> {
        return NSFetchRequest<UserLICDetail>(entityName: "UserLICDetail")
    }

    @NSManaged public var amount: String?
    @NSManaged public var date: String?
    @NSManaged public var months: String?
    @NSManaged public var name: String?
    @NSManaged public var personName: String?
    @NSManaged public var personNumber: String?
    @NSManaged public var policyNumber: String?
    @NSManaged public var policyName: String?
    @NSManaged public var type: String?
}
