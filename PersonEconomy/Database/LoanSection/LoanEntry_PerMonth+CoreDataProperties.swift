//
//  LoanEntry_PerMonth+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 20/01/21.
//
//

import Foundation
import CoreData


extension LoanEntry_PerMonth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoanEntry_PerMonth> {
        return NSFetchRequest<LoanEntry_PerMonth>(entityName: "LoanEntry_PerMonth")
    }

    @NSManaged public var amount: String?
    @NSManaged public var date: String?
    @NSManaged public var loanId: String?
    @NSManaged public var transactionId: String?
    @NSManaged public var payedDate: String?
}
