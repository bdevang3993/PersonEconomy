//
//  UserExpense+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 11/01/21.
//
//

import Foundation
import CoreData


extension UserExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserExpense> {
        return NSFetchRequest<UserExpense>(entityName: "UserExpense")
    }
    @NSManaged public var userExpenseId:String?
    @NSManaged public var itemName: String?
    @NSManaged public var price: String?
    @NSManaged public var sponserName: String?
    @NSManaged public var billRecips: Data?
    @NSManaged public var date:String?
    @NSManaged public var chequeNumber:String?
    @NSManaged public var shareMemberName:String?
}
