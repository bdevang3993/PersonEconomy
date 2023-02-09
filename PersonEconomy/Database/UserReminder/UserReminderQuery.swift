//
//  UserReminderQuery.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/12/21.
//
import Foundation
import CoreData
//MARK:- Database Maintains
struct UserReminderQuery {
    var userReminderData: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserReminder")
              
              //3
              do {
                userReminderData = try managedContext.fetch(fetchRequest)
              } catch _ as NSError {
               
              }
        if userReminderData.count > 0 {
                let array = convertToJSONArray(moArray: userReminderData)
            let lastobject = array[array.count - 1]
            recordBlock(lastobject["userReminderId"] as! Int)
           // return lastobject["userReminderId"] as! Int
        }
        else {
            recordBlock(-1)
        }
    }

    mutating func saveinDataBase(userReminderId:Int,reminderName:String,date:String,time:String,eventType:String,setType:String,amount:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserReminder",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(userReminderId, forKeyPath: "userReminderId")
        person.setValue(reminderName, forKeyPath: "reminderName")
        person.setValue(date, forKeyPath: "date")
        person.setValue(time, forKeyPath: "time")
        person.setValue(eventType, forKeyPath: "eventType")
        person.setValue(setType, forKey: "setType")
        person.setValue(amount, forKey: "amount")
        // 4
        do {
            try managedContext.save()
            userReminderData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
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
            NSFetchRequest<NSManagedObject>(entityName: "UserReminder")

          //3
          do {
            userReminderData = try managedContext.fetch(fetchRequest)
            if userReminderData.count > 0 {
                let array = convertToJSONArray(moArray: userReminderData)
                allData = array
            }
          } catch _ as NSError {
            recordBlock(allData)
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
            NSFetchRequest<NSManagedObject>(entityName: "UserReminder")
          fetchRequest.predicate = NSPredicate(format: "reminderName = %@",argumentArray:[name] )

          //3
          do {
            userReminderData = try managedContext.fetch(fetchRequest)
            if userReminderData.count > 0 {
                let array = convertToJSONArray(moArray: userReminderData)
                allData = array
            } else {
                recordBlock(allData)
            }
          } catch _ as NSError {
            recordBlock(allData)
          }
        recordBlock(allData)
    }
    
    func updateMember(userReminderId:Int,reminderName:String,date:String,time:String,eventType:String,setType:String,amount:String,success successBlock:@escaping ((Bool) -> Void)) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserReminder")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userReminderId = %ld",argumentArray:[Int64(userReminderId)])
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(reminderName, forKeyPath: "reminderName")
                results![0].setValue(date, forKey: "date")
                results![0].setValue(time, forKey: "time")
                results![0].setValue(eventType, forKey: "eventType")
                results![0].setValue(setType, forKeyPath: "setType")
                results![0].setValue(amount, forKeyPath: "amount")
            }
        } catch {
        }
        
        do {
            try context.save()
            successBlock(true)
            //return true
        }
        catch {
            successBlock(false)
            //return false
        }
    }
    
    func deleteuserData(userReminderId:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserReminder")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userReminderId = %d",argumentArray:[userReminderId])
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
            //return true
        }
        catch {
            successBlock(false)
            //return false
        }
    }
    
    func deleteAllEntryFromDB() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserReminder")
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        return true
    }
}
