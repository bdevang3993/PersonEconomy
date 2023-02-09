//
//  UserMedicalData+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 12/02/21.
//
//

import Foundation
import CoreData


extension UserMedicalData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMedicalData> {
        return NSFetchRequest<UserMedicalData>(entityName: "UserMedicalData")
    }
    @NSManaged public var userMedicalId:String?
    @NSManaged public var memberName: String?
    @NSManaged public var admittedDate: String?
    @NSManaged public var dischargeDate: String?
    @NSManaged public var amount: String?
    @NSManaged public var mediclamGet: String?
    @NSManaged public var mediclamType: String?
    @NSManaged public var contactPerson: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var hospitalName: String?
    
}
