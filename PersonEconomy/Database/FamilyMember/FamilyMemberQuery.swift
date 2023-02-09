//
//  FamilyMemberQuery.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/01/21.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct FamilyMemberQuery {
    var faimalyMember: [NSManagedObject] = []
    mutating func getLastId(record recordBlock: @escaping ((Int) -> Void)) {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                recordBlock(-1)
                  return
              }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserFamilyMember")
              
              //3
              do {
                faimalyMember = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if faimalyMember.count > 0 {
            let array = convertToJSONArray(moArray: faimalyMember)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["userid"] as! String)!)
            //return Int(lastobject["userid"] as! String)!
        }
        else {
            recordBlock(-1)
        }
    }
    
    mutating func saveinDataBase(userid:String,name:String,occupation:String,relationShip:String,number:String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserFamilyMember",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(userid, forKeyPath: "userid")
        person.setValue(name, forKeyPath: "name")
        person.setValue(occupation, forKeyPath: "occupation")
        person.setValue(relationShip, forKeyPath: "relationShip")
        person.setValue(number, forKeyPath: "number")
        // 4
        do {
            try managedContext.save()
            faimalyMember.append(person)
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
            NSFetchRequest<NSManagedObject>(entityName: "UserFamilyMember")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            faimalyMember = try managedContext.fetch(fetchRequest)
            if faimalyMember.count > 0 {
                let array = convertToJSONArray(moArray: faimalyMember)
                allData = array//profile as! [String:Any]
            } else {
                recordBlock(allData)
//                return allData
            }
          } catch _ as NSError {
            failureBlock(false)
          }
        recordBlock(allData)
    }
    func updateMember(userid:String,name:String,occupation:String,relationShip:String,number:String,success successBlock:@escaping ((Bool) -> Void)){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFamilyMember")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userid = %@",
                                             argumentArray:[userid] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(occupation, forKeyPath: "occupation")
                results![0].setValue(relationShip, forKeyPath: "relationShip")
                results![0].setValue(name, forKeyPath: "name")
                results![0].setValue(number, forKeyPath: "number")
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
    func deleteUserExpense(userid:String,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFamilyMember")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "userid = %@",argumentArray:[userid])
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
    func deleteAllEntryFromDB(success successBlock:@escaping ((Bool) -> Void)) {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFamilyMember")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            successBlock(false)
        } catch {
            // Error Handling
        }
        successBlock(true)
    }
}
