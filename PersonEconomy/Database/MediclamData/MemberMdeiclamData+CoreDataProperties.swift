//
//  MemberMdeiclamData+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 13/03/21.
//
//

import Foundation
import CoreData


extension MemberMdeiclamData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberMdeiclamData> {
        return NSFetchRequest<MemberMdeiclamData>(entityName: "MemberMdeiclamData")
    }

    @NSManaged public var memberId: String?
    @NSManaged public var memberName: String?
    @NSManaged public var policyNumber: String?
    @NSManaged public var startDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var agentName: String?
    @NSManaged public var agentNumber: String?
    @NSManaged public var type: String?
    @NSManaged public var price: String?
}
