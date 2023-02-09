//
//  LICEntryPerMonth.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 22/02/21.
//

import Foundation
import CoreData

struct LICEntryPerMonthQuery {
    var entryDetail: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LICEntryPerMonth")
              
              //3
              do {
                entryDetail = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if entryDetail.count > 0 {
            recordBlock(true)
        }
        else {
            recordBlock(false)
        }
    }

    mutating func saveEntryDetails(policyNumber:String,date:String,amount:String,billNumber:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "LICEntryPerMonth",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
       
        person.setValue(policyNumber, forKeyPath: "policyNumber")
        person.setValue(date, forKeyPath: "date")
        person.setValue(amount, forKeyPath: "amount")
        person.setValue(billNumber, forKey: "billNumber")
        person.setValue("", forKey: "payedDate")
        
        
        // 4
        do {
            try managedContext.save()
            entryDetail.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    
    mutating func fetchData(date:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "LICEntryPerMonth")
            fetchRequest.predicate = NSPredicate(format: "date = %@",date)
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            entryDetail = try managedContext.fetch(fetchRequest)
            if entryDetail.count > 0 {
                let array = convertToJSONArray(moArray: entryDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    
    
    mutating func fetchAllData(record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "LICEntryPerMonth")
         // fetchRequest.predicate = NSPredicate(format: "date = %@",date)
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            entryDetail = try managedContext.fetch(fetchRequest)
            if entryDetail.count > 0 {
                let array = convertToJSONArray(moArray: entryDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchAllDataById(policyNumber:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "LICEntryPerMonth")
          fetchRequest.predicate = NSPredicate(format: "policyNumber = %@",policyNumber)
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            entryDetail = try managedContext.fetch(fetchRequest)
            if entryDetail.count > 0 {
                let array = convertToJSONArray(moArray: entryDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    func updateEntryDetails(policyNumber:String,date:String,amount:String,billNumber:String,paiedDate:String,success successBlock:@escaping ((Bool) -> Void)) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LICEntryPerMonth")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "date = %@", date)
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(policyNumber, forKeyPath: "policyNumber")
                results![0].setValue(amount, forKeyPath: "amount")
                results![0].setValue(billNumber, forKeyPath: "billNumber")
                results![0].setValue(paiedDate, forKeyPath: "payedDate")
            }
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
    
    
    func deleteEntryDetails(policyNumber:String,success successBlock:@escaping ((Bool) -> Void))  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LICEntryPerMonth")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "policyNumber = %@",
                                                 argumentArray: [policyNumber])
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
    
    func deleteAllEntryFromDB(success successBlock:@escaping ((Bool) -> Void))  {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LICEntryPerMonth")
        
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
