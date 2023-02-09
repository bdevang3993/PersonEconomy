//
//  MemberMediclamDB.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 13/03/21.
//

import Foundation
import CoreData
//MARK:- Database Maintains

struct UserMediclamDB {
    var mediclamData: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MemberMdeiclamData")
              
              //3
              do {
                mediclamData = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if mediclamData.count > 0 {
            let array = convertToJSONArray(moArray: mediclamData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["memberId"] as! String)!)
        }
        else {
            recordBlock(-1)
        }
    }
    
    mutating func saveinDataBase(memberId:String,memberName:String,policyNumber:String,startDate:String,endDate:String,agentName:String,agentNumber:String,type:String,price:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "MemberMdeiclamData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        
        
        person.setValue(memberId, forKeyPath: "memberId")
        person.setValue(memberName, forKeyPath: "memberName")
        person.setValue(policyNumber, forKeyPath: "policyNumber")
        person.setValue(startDate, forKeyPath: "startDate")
        person.setValue(endDate, forKeyPath: "endDate")
        person.setValue(agentName, forKeyPath: "agentName")
        person.setValue(agentNumber, forKeyPath: "agentNumber")
        person.setValue(type, forKeyPath: "type")
        person.setValue(price, forKey: "price")
        // 4
        do {
            try managedContext.save()
            mediclamData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    
    mutating func fetchMedicalmData(record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "MemberMdeiclamData")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            mediclamData = try managedContext.fetch(fetchRequest)
            if mediclamData.count > 0 {
                let array = convertToJSONArray(moArray: mediclamData)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    
    mutating func fetchMediclamByName(memberName:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
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
            NSFetchRequest<NSManagedObject>(entityName: "MemberMdeiclamData")
          fetchRequest.predicate = NSPredicate(format: "memberName = %@",argumentArray:[memberName] )

          //3
          do {
            mediclamData = try managedContext.fetch(fetchRequest)
            if mediclamData.count > 0 {
                let array = convertToJSONArray(moArray: mediclamData)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    func updatemediclamDetail(policyNumber:String,startDate:String,endDate:String,agentName:String,agentNumber:String,type:String,success successBlock:@escaping ((Bool) -> Void)) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MemberMdeiclamData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "policyNumber = %@",
                                             argumentArray:[policyNumber] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(policyNumber, forKeyPath: "policyNumber")
                results![0].setValue(startDate, forKeyPath: "startDate")
                results![0].setValue(endDate, forKeyPath: "endDate")
                results![0].setValue(agentName, forKeyPath: "agentName")
                results![0].setValue(agentNumber, forKeyPath: "agentNumber")
                results![0].setValue(type, forKeyPath: "type")
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
    
    func deleteMediclamDetail(memberId:String,success successBlock:@escaping ((Bool) -> Void))  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MemberMdeiclamData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "memberId = %@", argumentArray:[memberId])
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
    
    func deleteAllEntryFromDB(success successBlock:@escaping ((Bool) -> Void))  {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MemberMdeiclamData")
        
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
