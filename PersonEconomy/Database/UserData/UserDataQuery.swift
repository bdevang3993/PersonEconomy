//
//  UserData.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 30/10/21.
//

import Foundation
import Foundation
import CoreData
//MARK:- Database Maintains
struct UserDataQuery {
    var userData: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")
              
              //3
              do {
                userData = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if userData.count > 0 {
                let array = convertToJSONArray(moArray: userData)
            let lastobject = array[array.count - 1]
            return recordBlock(Int(lastobject["userDataId"] as! String )!)
                //Int(lastobject["userDataId"] as! String )!
        }
        else {
            recordBlock(-1)
        }
    }

    mutating func saveinDataBase(userDataId:Int,name:String,startDate:String,endDate:String,image:Data,userMedicalId:String,price:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(userDataId, forKeyPath: "userDataId")
        person.setValue(name, forKeyPath: "name")
        person.setValue(startDate, forKeyPath: "startDate")
        person.setValue(endDate, forKeyPath: "endDate")
        person.setValue(userMedicalId, forKeyPath: "userMedicalId")
        person.setValue(price, forKey: "price")
        person.setValue(image, forKey: "image")
        // 4
        do {
            try managedContext.save()
            userData.append(person)
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
            NSFetchRequest<NSManagedObject>(entityName: "UserData")

          //3
          do {
            userData = try managedContext.fetch(fetchRequest)
            if userData.count > 0 {
                let array = convertToJSONArray(moArray: userData)
                allData = array
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    mutating func fetchDataByName(name:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserData")
          fetchRequest.predicate = NSPredicate(format: "name = %@",argumentArray:[name] )

          //3
          do {
            userData = try managedContext.fetch(fetchRequest)
            if userData.count > 0 {
                let array = convertToJSONArray(moArray: userData)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    func updateMember(userDataId:Int,startDate:String,endDate:String,image:Data,userMedicalId:String,price:String,success successBlock:@escaping ((Bool) -> Void))  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userDataId = %ld",argumentArray:[Int64(userDataId)])
        //NSPredicate(format: "itemName = %@,date = %@",argumentArray:[itemName,date] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(startDate, forKeyPath: "startDate")
                results![0].setValue(endDate, forKeyPath: "endDate")
                results![0].setValue(userMedicalId, forKey: "userMedicalId")
                results![0].setValue(price, forKey: "price")
                results![0].setValue(image, forKeyPath: "image")
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
    
    func deleteuserData(userDataId:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userDataId = %d",argumentArray:[userDataId])
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
    
    func deleteAllEntryFromDB(userMedicalId:String,success successBlock:@escaping ((Bool) -> Void))  {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        fetchRequest.predicate = NSPredicate(format: "userMedicalId = %@",argumentArray:[userMedicalId])
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
