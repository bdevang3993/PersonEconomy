//
//  UserExpenseQuery.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/01/21.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct UserExpenseQuery {
    var userExpense: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Int) -> Void))  {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                recordBlock(-1)
                  return
              }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserExpense")
              
              //3
              do {
                userExpense = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if userExpense.count > 0 {
                let array = convertToJSONArray(moArray: userExpense)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["userExpenseId"] as! String)!)
            //return
        }
        else {
            recordBlock(-1)
        }
    }

    mutating func saveinDataBase(userExpenseId:String,itemName:String,price:String,sponserName:String,date:String,billRecips:Data,chequeNumber:String,shareMemberName:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserExpense",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(userExpenseId, forKeyPath: "userExpenseId")
        person.setValue(itemName, forKeyPath: "itemName")
        person.setValue(price, forKeyPath: "price")
        person.setValue(sponserName, forKeyPath: "sponserName")
        person.setValue(date, forKey: "date")
        person.setValue(billRecips, forKey: "billRecips")
        person.setValue(chequeNumber, forKey: "chequeNumber")
        person.setValue(shareMemberName, forKey: "shareMemberName")
        // 4
        do {
            try managedContext.save()
            userExpense.append(person)
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
            NSFetchRequest<NSManagedObject>(entityName: "UserExpense")
            fetchRequest.predicate = NSPredicate(format: "date = %@",date)

          //3
          do {
            userExpense = try managedContext.fetch(fetchRequest)
            if userExpense.count > 0 {
                let array = convertToJSONArray(moArray: userExpense)
                allData = array
                recordBlock(allData)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchDataByName(sponserName:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserExpense")
          fetchRequest.predicate = NSPredicate(format: "sponserName = %@",argumentArray:[sponserName] )

          //3
          do {
            userExpense = try managedContext.fetch(fetchRequest)
            if userExpense.count > 0 {
                let array = convertToJSONArray(moArray: userExpense)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    mutating func fetchDataBySharedName(sponserName:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserExpense")
          fetchRequest.predicate = NSPredicate(format: "shareMemberName contains[c] %@",argumentArray:[sponserName,sponserName] )

          //3
          do {
            userExpense = try managedContext.fetch(fetchRequest)
            if userExpense.count > 0 {
                let array = convertToJSONArray(moArray: userExpense)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    func updateMember(userExpenseId:String,itemName:String,price:String,sponserName:String,date:String,billRecips:Data,chequeNumber:String,shareMemberName:String,success successBlock:@escaping ((Bool) -> Void))  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserExpense")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userExpenseId = %@ and date = %@", userExpenseId,date)
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(itemName, forKeyPath: "itemName")
                results![0].setValue(price, forKeyPath: "price")
                results![0].setValue(sponserName, forKeyPath: "sponserName")
                results![0].setValue(date, forKeyPath: "date")
                results![0].setValue(billRecips, forKeyPath: "billRecips")
                results![0].setValue(chequeNumber, forKeyPath: "chequeNumber")
                results![0].setValue(shareMemberName, forKey: "shareMemberName")
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
    
    func updateMemberWithSharedMember(userExpenseId:String,shareMemberName:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserExpense")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userExpenseId = %@", userExpenseId)
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                results![0].setValue(shareMemberName, forKey: "shareMemberName")
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
    func deleteUserExpense(userExpenseId:String,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserExpense")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userExpenseId = %@",argumentArray:[userExpenseId])
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
    
    func deleteAllEntry(startDate:String,endDate:String,success successBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserExpense")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)
        //fetchRequest.predicate = NSPredicate(format: "status = %@",argumentArray: ["Paied"])
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
    
    mutating func fetchAllData(startDate:String,endDate:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserExpense")
          fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate, endDate)

          //3
          do {
            userExpense = try managedContext.fetch(fetchRequest)
            if userExpense.count > 0 {
                let array = convertToJSONArray(moArray: userExpense)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    func deleteAllEntryFromDB(success successBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserExpense")
        
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
