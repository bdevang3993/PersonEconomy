//
//  StaticDatabase.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 06/12/21.
//

import Foundation
import Foundation
final class SetUpDatabase: NSObject {
   static var objShared = SetUpDatabase()
    var objUserProfile = UserProfileDatabaseQuerySetUp()
    var objUserExpanse = UserExpenseQuery()
    var objUserLoanDetailsQuery = UserLoanDetailsQuery()
    var objUserMediclamDB = UserMediclamDB()
    var objUserMedicalQuery = UserMedicalQuery()
    var objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
    var objUserLICDetailsQuery = UserLICDetailsQuery()
    var objUserDataQuery = UserDataQuery()
    var objPayerDetailsQuery = PayerDetailsQuery()
    var objFamilyMember = FamilyMemberQuery()
    var objLoanEntry = LoanEntry_PerMonthQuery()
    
    private override init() {
    }
    
    func fetchAllData(save success:@escaping((Bool) -> Void)){
        if let path = Bundle.main.path(forResource: "UserDetail", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]//mutableLeaves
                let arrBusinessDetails = jsonObj["SignUpDetail"] as! [Any]
                let dicData = arrBusinessDetails[0] as! [String:Any]
                objUserProfile.saveinDataBase(name: dicData["name"] as! String, birthDay: dicData["birthDay"]  as! String, gender: dicData["gender"]  as! String, contactNumber: dicData["contactNumber"]  as! String, emailId: dicData["emailId"]  as! String, password: dicData["password"]  as! String)

                
                let userDefault = UserDefaults()
                userDefault.setValue(dicData["contactNumber"] as! String, forKey: kContactNumber)
                userDefault.setValue(dicData["emailId"] as! String, forKey: kEmail)
                userDefault.setValue(dicData["password"] as! String, forKey: kPassword)
                userDefault.synchronize()
                KeychainService.saveEmail(email: dicData["emailId"]  as! NSString)
                KeychainService.savePassword(token: dicData["password"]! as! NSString)
                userDefault.synchronize()
                
                objFamilyMember.saveinDataBase(userid:"0",name: dicData["name"] as! String, occupation: "Business", relationShip:"Self", number: dicData["contactNumber"] as! String)
                
                
                let arrExpanse = jsonObj["UserExpense"] as! [Any]
                for expanse in arrExpanse {
                    let data = expanse as! [String:Any]
                    objUserExpanse.saveinDataBase(userExpenseId: data["userExpenseId"] as! String, itemName: data["itemName"] as! String, price: data["price"] as! String, sponserName: data["sponserName"] as! String, date: data["date"] as! String, billRecips: Data(), chequeNumber: "", shareMemberName: "")
                }
                
                let arrLoan = jsonObj["UserLoanDetails"] as! [Any]
                for loan in arrLoan {
                    let data = loan as! [String:Any]
                    objUserLoanDetailsQuery.saveLoanDetail(loanType: data["loanTYpe"] as! String, loanId: data["loanId"] as! String, memberName: data["memberName"] as! String, deductionAmount: data["deductionAmount"] as! String, startDate: data["startDate"] as! String, endDate: data["endDate"] as! String, totalAmount: data["totalAmount"] as! String, contactPerson: data["contactPerson"] as! String, referenceNumber: data["referenceNumber"] as! String, bankName: data["bankName"] as! String)
                    self.setupallDateandAddInDatabase(month: data["months"] as! String, strSelectedDate: data["startDate"] as! String, amount: data["deductionAmount"] as! String, loanId: data["loanId"] as! String)
                }
               
                let arrMediclamData = jsonObj["MemberMdeiclamData"] as! [Any]
                for mediclam in arrMediclamData {
                    let data = mediclam as! [String:Any]
                    objUserMediclamDB.saveinDataBase(memberId: data["memberId"] as! String, memberName: data["memberName"] as! String, policyNumber: data["policyNumber"] as! String, startDate: data["startDate"] as! String, endDate: data["endDate"] as! String, agentName: data["agentName"] as! String, agentNumber: data["agentNumber"] as! String, type: data["type"] as! String, price: data["price"] as! String)
                }
                
                let arrUserMedicalData = jsonObj["UserMedicalData"] as! [Any]
                for medicalData in arrUserMedicalData {
                    let data = medicalData as! [String:Any]
                    objUserMedicalQuery.saveinDataBase(admittedDate: data["admittedDate"] as! String, amount: data["amount"] as! String, contactNumber: data["contactNumber"] as! String, contactPerson: data["contactPerson"] as! String, dischargeDate: data["dischargeDate"] as! String, mediclamGet: data["mediclamGet"] as! String, mediclamType: data["mediclamType"] as! String, memberName: data["memberName"] as! String, hospitalName: data["hospitalName"] as! String, userMedicalId: data["userMedicalId"] as! String)
                }
                
                let arrLICDetailData = jsonObj["UserLICDetail"] as! [Any]
                for licdetail in arrLICDetailData {
                    let data = licdetail as! [String:Any]
                    objUserLICDetailsQuery.saveLICDetail(name: data["name"] as! String, policyNumber: data["policyNumber"] as! String, date: data["date"] as! String, months: data["months"] as! String, amount: data["amount"] as! String, personName: data["personNumber"] as! String, personNumber: data["personNumber"] as! String, policyName: data["policyName"] as! String, type: data["type"] as! String)
                    self.setupallLICDateandAddInDatabase(month: data["months"] as! String, strSelectedDate: data["date"] as! String, amount: data["amount"] as! String, policyNumber: data["policyNumber"] as! String)
                }
                
                let arrUserData = jsonObj["UserData"] as! [Any]
                for userData in arrUserData {
                    let data = userData as! [String:Any]
                    objUserDataQuery.saveinDataBase(userDataId: data["userDataId"] as! Int, name: data["name"] as! String, startDate: data["startDate"] as! String, endDate: data["endDate"] as! String, image: Data(), userMedicalId: data["userMedicalId"] as! String, price: data["price"] as! String)
                }
                
                let arrPayerDetails = jsonObj["PayerDetails"] as! [Any]
                let dicDataPayer = arrPayerDetails[0] as! [String:Any]
                
                objPayerDetailsQuery.saveinDataBase(id: dicDataPayer["id"] as! Int, strName: dicDataPayer["name"] as! String, strURL: dicDataPayer["strUrl"] as! String)
                success(true)
            }
            catch {
                success(false)
            }
        }
    }
    func setupallDateandAddInDatabase(month:String,strSelectedDate:String,amount:String,loanId:String)  {
        let totalMonth = Int(month)
        let date = strSelectedDate
        var strNewDate:String = ""
        for i in 0...totalMonth! - 1 {
            if  i == 0 {
                strNewDate = date
            } else {
                strNewDate = self.countEndDate(strDate: strNewDate, month:"1")
            }
             objLoanEntry.saveEntryDetails(loanId: loanId, date: strNewDate, amount: amount, transactionId: "")
        }
    }
    func setupallLICDateandAddInDatabase(month:String,strSelectedDate:String,amount:String,policyNumber:String)  {
          let totalMonth = Int(month)
        let totalCount:Int = totalMonth!
        let addMonths:String = "12"
          var strNewDate:String = ""
          strNewDate = strSelectedDate
          let date = strSelectedDate

          for i in 0...totalCount - 1 {
              if  i == 0 {
                strNewDate = date
              } else {
                strNewDate = self.countEndDate(strDate: strNewDate, month: addMonths)
              }
             
              _ = objLICEntryPerMonthQuery.saveEntryDetails(policyNumber: policyNumber, date:strNewDate , amount: amount, billNumber: "")
          }
      }
    
    func countEndDate(strDate:String,month:String) -> String {
        
        let isoDate = strDate//"2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from:isoDate)!
        var dateComponent = DateComponents()
        let totalMonts = Int(month)
        let year = totalMonts!/12
        let newMonth = totalMonts! % 12
        dateComponent.year = year
        dateComponent.month = newMonth
        let futureDate = date.addMonth(n: totalMonts!)
        let newDate = dateFormatter.string(from: futureDate)
        return newDate
    }
}
