//
//  LICDetail.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 22/02/21.
//

import Foundation
import CoreData

struct UserLICDetailsQuery {
    var licDetail: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Bool) -> Void))  {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                  recordBlock(false)
                  return
              }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserLICDetail")
              
              //3
              do {
                licDetail = try managedContext.fetch(fetchRequest)
              
                
              } catch  _ as NSError {
               
              }
        if licDetail.count > 0 {
            recordBlock(true)
        }
        else {
            recordBlock(false)
        }
    }

    mutating func saveLICDetail(name:String,policyNumber:String,date:String,months:String,amount:String,personName:String,personNumber:String,policyName:String,type:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserLICDetail",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        

       
        person.setValue(name, forKeyPath: "name")
        person.setValue(policyNumber, forKeyPath: "policyNumber")
        person.setValue(date, forKeyPath: "date")
        person.setValue(months, forKey: "months")
        person.setValue(amount, forKey: "amount")
        person.setValue(personName, forKey: "personName")
        person.setValue(personNumber, forKey: "personNumber")
        person.setValue(policyName, forKey: "policyName")
        person.setValue(type, forKey: "type")
        // 4
        do {
            try managedContext.save()
            licDetail.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    
    mutating func fetchLICDataUsingID(policyNumber:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserLICDetail")
            fetchRequest.predicate = NSPredicate(format: "policyNumber = %@", policyNumber)

          //3
          do {
            licDetail = try managedContext.fetch(fetchRequest)
            if licDetail.count > 0 {
                let array = convertToJSONArray(moArray: licDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    
    mutating func fetchData(record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserLICDetail")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            licDetail = try managedContext.fetch(fetchRequest)
            if licDetail.count > 0 {
                let array = convertToJSONArray(moArray: licDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch  _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    mutating func fetchDataByName(name:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserLICDetail")
            fetchRequest.predicate = NSPredicate(format: "name = %@",argumentArray:[name] )

          //3
          do {
            licDetail = try managedContext.fetch(fetchRequest)
            if licDetail.count > 0 {
                let array = convertToJSONArray(moArray: licDetail)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    
    
        
    func updateLICDetails(name:String,policyNumber:String,date:String,months:String,amount:String,personName:String,personNumber:String,policyName:String,success successBlock:@escaping ((Bool) -> Void))  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLICDetail")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "policyNumber = %@", policyNumber)
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(name, forKeyPath: "name")
                results![0].setValue(policyNumber, forKeyPath: "policyNumber")
                results![0].setValue(date, forKeyPath: "date")
                results![0].setValue(months, forKeyPath: "months")
                results![0].setValue(amount, forKeyPath: "amount")
                results![0].setValue(personName, forKeyPath: "personName")
                results![0].setValue(personNumber, forKeyPath: "personNumber")
                results![0].setValue(personNumber, forKeyPath: "policyName")
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
    
    func deleteLICDetail(policyNumber:String,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLICDetail")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "policyNumber = %@", policyNumber)
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
    func deleteAllEntryFromDB(successBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLICDetail")
        
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
