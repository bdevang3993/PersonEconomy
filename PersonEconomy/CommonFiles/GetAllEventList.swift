//
//  getAllEventList.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 24/08/21.
//

import Foundation
final class GetAllEventList:NSObject {
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    static var shared = GetAllEventList()
    var objLoanEntry = LoanEntry_PerMonthQuery()
    var objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
    var objMediclamData = UserMediclamDB()
    var objReminderList = UserReminderQuery()
    var checkForDays:Int = 20
    var arrCombineData = [[String:Any]]()
    func fetchAllEvent(eventData: @escaping (([[String:Any]]) -> Void)) {
        arrCombineData.removeAll()
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        var dicData = [String:Any]()
        objLoanEntry.fetchAllData { (result) in
            if result.count > 0 {
                for arrLoanData in result {
                    let strDate = arrLoanData["date"]
                    let checkForDate:Date = self.dateFormatter.date(from: strDate as! String)!
                    let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to: checkForDate).day!
                    if diffInDays < self.checkForDays && diffInDays > 0 {
                        dicData = arrLoanData
                        dicData["eventType"] = "Loan"
                        dicData["daysRemaining"] = "\(diffInDays)"
                        self.arrCombineData.append(dicData)
                    }
                }
            }
        } failure: { (isfailed) in
        }
        objLICEntryPerMonthQuery.fetchAllData { (result) in
            if result.count > 0 {
                for arrdisplayDate in result {
                    let strDate = arrdisplayDate["date"]
                    let checkForDate:Date = self.dateFormatter.date(from: strDate as! String)!
                    let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to: checkForDate).day!
                    if diffInDays < self.checkForDays && diffInDays > 0 {
                        dicData = arrdisplayDate
                        dicData["eventType"] = "LIC"
                        dicData["daysRemaining"] = "\(diffInDays)"
                        self.arrCombineData.append(dicData)
                    }
                }
            }
        } failure: { (isFailed) in
        }


        
        objMediclamData.fetchMedicalmData { (result) in
            if result.count > 0 {
                for dicMediclamData in result {
                    let strDate = dicMediclamData["endDate"]
                    let checkForDate:Date = self.dateFormatter.date(from: strDate as! String)!
                    let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to: checkForDate).day!
                    if diffInDays < self.checkForDays && diffInDays > 0 {
                        dicData = dicMediclamData
                        dicData["date"] = dicMediclamData["endDate"]
                        dicData["eventType"] = "Mediclame"
                        dicData["daysRemaining"] = "\(diffInDays)"
                        self.arrCombineData.append(dicData)
                    }
                }
            }
        } failure: { (isSuccess) in
        }

        //let arrMediclamData = objMediclamData.fetchMedicalmData()

        
        
        objReminderList.fetchData { (arrReminderList) in
            if arrReminderList.count > 0 {
                for dicReminderData in arrReminderList {
                    let strDate = dicReminderData["date"]
                    let checkForDate:Date = self.dateFormatter.date(from: strDate as! String)!
                    let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to: checkForDate).day!
                        dicData = dicReminderData
                        dicData["date"] = dicReminderData["date"]
                        dicData["eventType"] = dicReminderData["reminderName"]
                        dicData["daysRemaining"] = "\(diffInDays)"
                    self.arrCombineData.append(dicData)
                }
            }
            eventData(self.arrCombineData)
        } failure: { (isfailed) in
        }
    }
    
}
