//
//  UserAdvanceQuery.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 26/02/21.
//

import UIKit
import CoreData
struct UserAdvanceQuery {
    var userAdvanceDetail: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Int) -> Void)) {
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            recordBlock(-1)
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserAdvanceDetail")
        
        //3
        do {
            userAdvanceDetail = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if userAdvanceDetail.count > 0 {
            let array = convertToJSONArray(moArray: userAdvanceDetail)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["advanceId"] as! String)!)
            //return Int(lastobject["advanceId"] as! String)!
        }
        else {
            recordBlock(-1)
        }
    }

    mutating func saveuserAdvanceDetail(advanceId:String,date:String,item:String,name:String,paidDate:String,price:String,status:String,transactionId:String,userExpenseId:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserAdvanceDetail",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        

        person.setValue(advanceId, forKeyPath: "advanceId")
        person.setValue(date, forKeyPath: "date")
        person.setValue(item, forKeyPath: "item")
        person.setValue(name, forKey: "name")
        person.setValue(paidDate, forKey: "paidDate")
        person.setValue(price, forKey: "price")
        person.setValue(status, forKey: "status")
        person.setValue(transactionId, forKey: "transactionId")
        person.setValue(userExpenseId, forKey: "userExpenseId")
        // 4
        do {
            try managedContext.save()
            userAdvanceDetail.append(person)
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
            NSFetchRequest<NSManagedObject>(entityName: "UserAdvanceDetail")

          //3
          do {
            userAdvanceDetail = try managedContext.fetch(fetchRequest)
            if userAdvanceDetail.count > 0 {
                let array = convertToJSONArray(moArray: userAdvanceDetail)
                allData = array//profile as! [String:Any]
            } else {
                recordBlock(allData)
                //return allData
            }
          } catch _ as NSError {
            recordBlock(allData)
          }
        recordBlock(allData)
    }
        
    mutating func fetchDataUsingDate(date:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserAdvanceDetail")
            fetchRequest.predicate = NSPredicate(format: "date = %@", date)

          //3
          do {
            userAdvanceDetail = try managedContext.fetch(fetchRequest)
            if userAdvanceDetail.count > 0 {
                let array = convertToJSONArray(moArray: userAdvanceDetail)
                allData = array//profile as! [String:Any]
            } else {
                recordBlock(allData)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchDataUsingName(name:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserAdvanceDetail")
            fetchRequest.predicate = NSPredicate(format: "name = %@", name)

          //3
          do {
            userAdvanceDetail = try managedContext.fetch(fetchRequest)
            if userAdvanceDetail.count > 0 {
               
                let array = convertToJSONArray(moArray: userAdvanceDetail)
                allData = array
            } else {
                recordBlock(allData)
                //return allData
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchDataUsingNameAndStatus(name:String,status:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserAdvanceDetail")
            fetchRequest.predicate = NSPredicate(format: "name = %@ AND status = %@", argumentArray: [name, status])

          //3
          do {
            userAdvanceDetail = try managedContext.fetch(fetchRequest)
            if userAdvanceDetail.count > 0 {
                let array = convertToJSONArray(moArray: userAdvanceDetail)
                allData = array
            } else {
               failureBlock(false)
            }
          } catch  _ as NSError {
            failureBlock(false)
           // return allData
          }
        recordBlock(allData)
    }
    
    func updateuserAdvanceDetails(date:String,item:String,name:String,paidDate:String,price:String,status:String,transactionId:String,advanceId:String,userExpenseId:String,succees succeesBlock:@escaping ((Bool) -> Void)) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAdvanceDetail")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "date = %@ AND advanceId = %@",
                                                 argumentArray: [date, advanceId])

        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(name, forKeyPath: "name")
                results![0].setValue(item, forKeyPath: "item")
                results![0].setValue(paidDate, forKeyPath: "paidDate")
                results![0].setValue(price, forKeyPath: "price")
                results![0].setValue(status, forKeyPath: "status")
                results![0].setValue(transactionId, forKeyPath: "transactionId")
                results![0].setValue(userExpenseId, forKey: "userExpenseId")
            }
        } catch {
        }
        
        do {
            try context.save()
            succeesBlock(true)
        }
        catch {
            succeesBlock(false)
        }
    }
    
    func deleteuserAdvanceDetail(advanceId:String,succees succeesBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAdvanceDetail")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "advanceId = %@",
                                                 argumentArray: [advanceId])
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        var result:[NSManagedObject]?
        do {
             result = try context.fetch(fetchRequest) as? [NSManagedObject]
            context.delete(result![0])
        } catch {
        }
        
        do {
            try context.save()
            succeesBlock(true)
        }
        catch {
            succeesBlock(false)
        }
    }
    
    func deleteAllEntry(succees succeesBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAdvanceDetail")
        fetchRequest.predicate = NSPredicate(format: "status = %@",
                                                 argumentArray: ["Paied"])
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        succeesBlock(true)
    }
    
    func deleteAllEntryFromDB(succees succeesBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAdvanceDetail")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
            succeesBlock(false)
        }
        succeesBlock(true)
    }
}
