//
//  AllMemberList.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 13/03/21.
//

import UIKit

final class AllMemberList: NSObject {
 static var shared = AllMemberList()
    var objFamilyMemberQuery = FamilyMemberQuery()
   private override init() {
    }
    func getMemberList(record recordBlock: @escaping (([[String:Any]]) -> Void)) {
       // let data = objFamilyMemberQuery.getLastId()
        objFamilyMemberQuery.getLastId { (data) in
            if data >= 0 {
                arrMemberList.removeAll()
                DispatchQueue.global(qos: .userInitiated).async {
                     arrMemberList = convertToJSONArray(moArray: self.objFamilyMemberQuery.faimalyMember)
                    recordBlock(arrMemberList)
                }
            } else {
                recordBlock(arrMemberList)
            }
        }
    }
    
    
    func getNameArray() -> [String]  {
        var arrAllMember = [String]()
        for member in arrMemberList {
            let name = member["name"]
            arrAllMember.append(name as! String)
        }
        return arrAllMember
    }
    func getCustomerNameArray() -> [String]  {
        var arrAllMember = [String]()
        for member in arrMemberList {
            if let customertype = member["relationShip"] {
                if customertype as! String == kCustomer {
                    let name = member["name"]
                    arrAllMember.append(name as! String)
                }
            }
        }
        return arrAllMember
    }
}
