//
//  UserProfileDatabaseQuery.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 09/01/21.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct UserProfileDatabaseQuerySetUp {
    var people: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserProfile")
              
              //3
              do {
                people = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if people.count > 0 {
           recordBlock(true)
        }
        else {
           recordBlock(false)
        }
    }
    
    mutating func saveinDataBase(name:String,birthDay:String,gender:String,contactNumber:String,emailId:String,password:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserProfile",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
       
        person.setValue(name, forKeyPath: "name")
        person.setValue(gender, forKeyPath: "gender")
        person.setValue(emailId, forKeyPath: "emailId")
        person.setValue(contactNumber, forKeyPath: "contactNumber")
        person.setValue(birthDay, forKeyPath: "birthDay")
        person.setValue(password, forKeyPath: "password")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    
    mutating func fetchAllData(record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var dicData = [String:Any]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              recordBlock(dicData)
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserProfile")
//          fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",
//                                                          argumentArray:[contactNumber] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = convertToJSONArray(moArray: people)
                dicData = array[0]
            } else {
                recordBlock(dicData)
            }
          } catch let _ as NSError {
            recordBlock(dicData)
          }
        recordBlock(dicData)
    }
    
    
    
    
    
    
    mutating func fetchData(record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var dicData = [String:Any]()
          //1
          guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
            recordBlock(dicData)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserProfile")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = convertToJSONArray(moArray: people)
                dicData = array[0]
            } else {
                recordBlock(dicData)
            }
          } catch let _ as NSError {
            recordBlock(dicData)
          }
        recordBlock(dicData)
    }
    
    
    
    func updateDataBase(name:String,birthDay:String,gender:String,contactNumber:String,emailId:String,success successBlock:@escaping ((Bool) -> Void)) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",
                                             argumentArray:[contactNumber] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(gender, forKeyPath: "gender")
                results![0].setValue(emailId, forKeyPath: "emailId")
                results![0].setValue(name, forKeyPath: "name")
                results![0].setValue(birthDay, forKeyPath: "birthDay")
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
    
    func deleteAllEntryFromDB(success successBlock:@escaping ((Bool) -> Void))  {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        
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

