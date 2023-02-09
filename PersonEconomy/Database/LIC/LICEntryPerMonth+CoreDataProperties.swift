//
//  LICEntryPerMonth+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 22/02/21.
//
//

import Foundation
import CoreData


extension LICEntryPerMonth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LICEntryPerMonth> {
        return NSFetchRequest<LICEntryPerMonth>(entityName: "LICEntryPerMonth")
    }

    @NSManaged public var amount: String?
    @NSManaged public var billNumber: String?
    @NSManaged public var date: String?
    @NSManaged public var policyNumber: String?
    @NSManaged public var payedDate: String?
}
