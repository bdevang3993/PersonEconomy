//
//  UserMedicalQuery.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 12/02/21.
//

import Foundation
import CoreData
//MARK:- Database Maintains

struct UserMedicalQuery {
    var medicalData: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserMedicalData")
              
              //3
              do {
                medicalData = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if medicalData.count > 0 {
            let array = convertToJSONArray(moArray: medicalData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["userMedicalId"] as! String)!)
        }
        else {
            recordBlock(-1)
        }
    }
    
    mutating func saveinDataBase(admittedDate:String,amount:String,contactNumber:String,contactPerson:String,dischargeDate:String,mediclamGet:String,mediclamType:String,memberName:String,hospitalName:String,userMedicalId:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserMedicalData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
       
        person.setValue(admittedDate, forKeyPath: "admittedDate")
        person.setValue(amount, forKeyPath: "amount")
        person.setValue(contactNumber, forKeyPath: "contactNumber")
        person.setValue(contactPerson, forKeyPath: "contactPerson")
        person.setValue(dischargeDate, forKeyPath: "dischargeDate")
        person.setValue(mediclamGet, forKeyPath: "mediclamGet")
        person.setValue(mediclamType, forKeyPath: "mediclamType")
        person.setValue(memberName, forKeyPath: "memberName")
        person.setValue(hospitalName, forKeyPath: "hospitalName")
        person.setValue(userMedicalId, forKey: "userMedicalId")
        // 4
        do {
            try managedContext.save()
            medicalData.append(person)
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
            NSFetchRequest<NSManagedObject>(entityName: "UserMedicalData")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            medicalData = try managedContext.fetch(fetchRequest)
            if medicalData.count > 0 {
                let array = convertToJSONArray(moArray: medicalData)
                allData = array
            } else {
                failureBlock(false)
            }
          } catch let _ as NSError {
            failureBlock(false)
          }
        return recordBlock(allData)
    }
    
    
    mutating func fetchDataByName(memberName:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserMedicalData")
          fetchRequest.predicate = NSPredicate(format: "memberName = %@",argumentArray:[memberName] )

          //3
          do {
            medicalData = try managedContext.fetch(fetchRequest)
            if medicalData.count > 0 {
                let array = convertToJSONArray(moArray: medicalData)
                allData = array//profile as! [String:Any]
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    
    func updateMember(admittedDate:String,amount:String,contactNumber:String,contactPerson:String,dischargeDate:String,mediclamGet:String,mediclamType:String,memberName:String,hospitalName:String,userMedicalId:String,success successBlock:@escaping ((Bool) -> Void)) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMedicalData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userMedicalId = %@",
                                             argumentArray:[userMedicalId] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(admittedDate, forKeyPath: "admittedDate")
                results![0].setValue(amount, forKeyPath: "amount")
                results![0].setValue(contactNumber, forKeyPath: "contactNumber")
                results![0].setValue(contactPerson, forKeyPath: "contactPerson")
                results![0].setValue(dischargeDate, forKeyPath: "dischargeDate")
                results![0].setValue(mediclamGet, forKeyPath: "mediclamGet")
                results![0].setValue(mediclamType, forKeyPath: "mediclamType")
                results![0].setValue(memberName, forKeyPath: "memberName")
                results![0].setValue(hospitalName, forKeyPath: "hospitalName")
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
    
    func deleteMedicalDetail(userMedicalId:String,success successBlock:@escaping ((Bool) -> Void))  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMedicalData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userMedicalId = %@", argumentArray:[userMedicalId])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMedicalData")
        
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
