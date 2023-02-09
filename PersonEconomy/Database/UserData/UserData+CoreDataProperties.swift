//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 30/10/21.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var startDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var userMedicalId:String?
    @NSManaged public var userDataId: Int
    @NSManaged public var price:String?
}
