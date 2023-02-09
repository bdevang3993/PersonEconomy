//
//  LoaderViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 18/09/21.
//

import UIKit
import CoreData
class LoaderViewController: UIViewController {
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    var isFromDelete:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewMain.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        if isFromDelete {
            self.destroyPersistentStore()
            self.deleteAllEntry()
        } else {
            self.restoreFromStore(backupName: kPersonDataBase)
        }
    }
    func destroyPersistentStore() {
        let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let storeUrl = storeFolderUrl.appendingPathComponent("\(kPersonDataBase).sqlite")
        let filerManager = FileManager.default
        do{
           try filerManager.removeItem(at: storeUrl)
            self.destoryLocalFolder()
        } catch {
        }
    }
    
    func destoryLocalFolder() {
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(kPersonDataBase + ".sqlite")
        let filerManager1 = FileManager.default
        do{
           try filerManager1.removeItem(at: backupUrl)
        } catch {
        }
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let stores = container.persistentStoreCoordinator.persistentStores
            let filerManager2 = FileManager.default
            do{
                try filerManager2.removeItem(at: stores[0].url!)
            } catch {
            }
        })
       
    }
    func moveToMainPage() {
        DispatchQueue.main.async {
            let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
            self.view.window?.rootViewController = initialViewController
        }
    }
    func deleteAllEntry() {
        let userdefault = UserDefaults.standard
        let email = userdefault.value(forKey: kEmail)
        let password = userdefault.value(forKey: kPassword)
        if email != nil {
            KeychainService.deleteEmail(email: email as! NSString)
            KeychainService.deletePassword(password: password as! NSString)
        }
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        MBProgressHub.showLoadingSpinner(sender: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
       let objUserLoanEntry =  UserLoanDetailsQuery()
            objUserLoanEntry.deleteAllEntry { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)  {
            let objUserAdvanceQuery = UserAdvanceQuery()
            objUserAdvanceQuery.deleteAllEntry { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5)  {
            let objUserProfileDatabaseQuerySetUp = UserProfileDatabaseQuerySetUp()
            objUserProfileDatabaseQuerySetUp.deleteAllEntryFromDB { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7)  {
            let objFamilyMemberQuery = FamilyMemberQuery()
            objFamilyMemberQuery.deleteAllEntryFromDB { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9)  {
            let objUserExpenseQuery = UserExpenseQuery()
            objUserExpenseQuery.deleteAllEntryFromDB { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11)  {
            let objUserLoanDetailsQuery = UserLoanDetailsQuery()
            objUserLoanDetailsQuery.deleteAllEntry { (isSuccess) in
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 13)  {
            let objLoanEntry_PerMonthQuery = LoanEntry_PerMonthQuery()
            objLoanEntry_PerMonthQuery.deleteAllEntryFromDB { (isSuccess) in
            }

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15)  {
            let objUserMedicalQuery = UserMedicalQuery()
            objUserMedicalQuery.deleteAllEntryFromDB { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 17)  {
            let objUserMediclamDB = UserMediclamDB()
            objUserMediclamDB.deleteAllEntryFromDB { (isSuccess) in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 19)  {
            let objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
            objLICEntryPerMonthQuery.deleteAllEntryFromDB(success: { (isSucccess) in
                
            })

            self.backup(backupName: kPersonDataBase)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 21)  {
            let objUserLICDetailsQuery = UserLICDetailsQuery()
            objUserLICDetailsQuery.deleteAllEntryFromDB { (isSuccess) in
                
            }
//            if objUserLICDetailsQuery.deleteAllEntryFromDB() {
//            }
            self.backup(backupName: kPersonDataBase)
            self.moveToMainPage()
        }
        
    }
    
    func backup(backupName: String){
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        MBProgressHub.dismissLoadingSpinner(self.view)
        let store:NSPersistentStore
        if container.persistentStoreCoordinator.persistentStores.last != nil {
            store = container.persistentStoreCoordinator.persistentStores.last!
            do {
                try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
               
            } catch {
            }
        }
    }

    
    func restoreFromStore(backupName: String){
        MBProgressHub.showLoadingSpinner(sender: self.view)
            let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
            let storeUrl = storeFolderUrl.appendingPathComponent("\(backupName).sqlite")
            let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
            let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")

            let container = NSPersistentContainer(name: kPersistanceStorageName)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                let stores = container.persistentStoreCoordinator.persistentStores
                for _ in stores {
                    isDataBaseAvailable = true
                }
                do{
                    try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
                    self.moveToHomePage()
                } catch {
                    self.moveToHomePage()
                }
            })
        }
    
    func moveToHomePage() {
        MBProgressHub.dismissLoadingSpinner(self.view)
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: MainStoryBoard, bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.view.window?.rootViewController = initialViewController
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
