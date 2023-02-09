//
//  UserAdvanceDetail+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 26/02/21.
//
//

import Foundation
import CoreData


extension UserAdvanceDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAdvanceDetail> {
        return NSFetchRequest<UserAdvanceDetail>(entityName: "UserAdvanceDetail")
    }
    @NSManaged public var advanceId: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var item: String?
    @NSManaged public var status: String?
    @NSManaged public var transactionId: String?
    @NSManaged public var date: String?
    @NSManaged public var paidDate: String?
    @NSManaged public var userExpenseId:String?
    
}
