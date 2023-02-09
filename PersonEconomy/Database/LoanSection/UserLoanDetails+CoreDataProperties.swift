//
//  UserLoanDetails+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 20/01/21.
//
//

import Foundation
import CoreData


extension UserLoanDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLoanDetails> {
        return NSFetchRequest<UserLoanDetails>(entityName: "UserLoanDetails")
    }

    @NSManaged public var contactPerson: String?
    @NSManaged public var deductionAmount: String?
    @NSManaged public var endDate: String?
    @NSManaged public var loanId: String?
    @NSManaged public var loanTYpe: String?
    @NSManaged public var memberName: String?
    @NSManaged public var referenceNumber: String?
    @NSManaged public var startDate: String?
    @NSManaged public var totalAmount: String?
    @NSManaged public var bankName:String?

}
