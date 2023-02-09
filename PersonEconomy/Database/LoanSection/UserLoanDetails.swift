//
//  UserLoanDetails.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 19/01/21.
//

import Foundation
import CoreData

struct UserLoanDetailsQuery {
    var loanDetail: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Bool) -> Void)) {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                recordBlock(false)
                return
              }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserLoanDetails")
              
              //3
              do {
                loanDetail = try managedContext.fetch(fetchRequest)
              
                
              } catch let _ as NSError {
               
              }
        if loanDetail.count > 0 {
            recordBlock(true)
        }
        else {
            recordBlock(false)
        }
    }

    mutating func saveLoanDetail(loanType:String,loanId:String,memberName:String,deductionAmount:String,startDate:String,endDate:String,totalAmount:String,contactPerson:String,referenceNumber:String,bankName:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserLoanDetails",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        

       
        person.setValue(loanType, forKeyPath: "loanTYpe")
        person.setValue(loanId, forKeyPath: "loanId")
        person.setValue(memberName, forKeyPath: "memberName")
        person.setValue(deductionAmount, forKey: "deductionAmount")
        person.setValue(startDate, forKey: "startDate")
        person.setValue(endDate, forKey: "endDate")
        person.setValue(totalAmount, forKey: "totalAmount")
        person.setValue(contactPerson, forKey: "contactPerson")
        person.setValue(referenceNumber, forKey: "referenceNumber")
        person.setValue(bankName, forKey: "bankName")
        
        // 4
        do {
            try managedContext.save()
            loanDetail.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    
    mutating func fetchData(record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var allData = [[String:Any]]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserLoanDetails")

          //3
          do {
            loanDetail = try managedContext.fetch(fetchRequest)
            if loanDetail.count > 0 {
                let array = convertToJSONArray(moArray: loanDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchDataByName(memberName:String,record recordBlock:@escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var allData = [[String:Any]]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserLoanDetails")
          fetchRequest.predicate = NSPredicate(format: "memberName = %@",argumentArray:[memberName] )

          //3
          do {
            loanDetail = try managedContext.fetch(fetchRequest)
            if loanDetail.count > 0 {
                let array = convertToJSONArray(moArray: loanDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchDataByLoanId(loanId:String,record recordBlock:@escaping(([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var allData = [[String:Any]]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserLoanDetails")
          fetchRequest.predicate = NSPredicate(format: "loanId = %@",argumentArray:[loanId] )

          //3
          do {
            loanDetail = try managedContext.fetch(fetchRequest)
            if loanDetail.count > 0 {
                let array = convertToJSONArray(moArray: loanDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    
    func updateLoanDetails(loanType:String,loanId:String,memberName:String,deductionAmount:String,startDate:String,endDate:String,totalAmount:String,contactPerson:String,referenceNumber:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLoanDetails")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "loanId = %@", loanId)
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(loanType, forKeyPath: "loanType")
                results![0].setValue(loanId, forKeyPath: "loanId")
                results![0].setValue(memberName, forKeyPath: "memberName")
                results![0].setValue(deductionAmount, forKeyPath: "deductionAmount")
                results![0].setValue(startDate, forKeyPath: "startDate")
                results![0].setValue(endDate, forKeyPath: "endDate")
                results![0].setValue(totalAmount, forKeyPath: "totalAmount")
                results![0].setValue(contactPerson, forKeyPath: "contactPerson")
                results![0].setValue(referenceNumber, forKeyPath: "referenceNumber")
            }
        } catch {
        }
        
        do {
            try context.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func deleteLoanDetail(loanId:String,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLoanDetails")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "loanId = %@", loanId)
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        var result:[NSManagedObject]?
        
        do {
             result = try context.fetch(fetchRequest) as? [NSManagedObject]
            context.delete(result![0])
        } catch {
        }
        
        do {
            try context.save()
            successBlock(true)
        }
        catch {
            successBlock(false)
        }
    }
    
    func deleteAllEntry(success successBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLoanDetails")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
            successBlock(false)
        }
        successBlock(true)
    }
}
