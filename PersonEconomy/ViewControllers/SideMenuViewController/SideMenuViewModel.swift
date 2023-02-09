//
//  SideMenuViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit


class SideMenuViewModel: NSObject {
    var arrDescription = ["Home","Search All Data","Loan","Medical","LIC","Account Details","Search Account Details","Event Details","Document","Save Payer QR","Profile","Change Password","Restore Data from back up","Delete Data","Logout"]
    
}
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return 50.0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSideMenuViewModel.arrDescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "RearTableViewCell") as! RearTableViewCell
        cell.lblDescrption.text = objSideMenuViewModel.arrDescription[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let objHomeView:HomeViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            self.revealViewController()?.pushFrontViewController(objHomeView, animated: true)
        }
        if indexPath.row == 1 {
            let objSearchView:CommonSearchViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "CommonSearchViewController") as! CommonSearchViewController
            self.revealViewController()?.pushFrontViewController(objSearchView, animated: true)
        }
        if indexPath.row == 2 {
            let objLoan:LoanDisplayViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "LoanDisplayViewController") as! LoanDisplayViewController
            self.revealViewController()?.pushFrontViewController(objLoan, animated: true)
        }
        if indexPath.row == 3 {
            let objHospital:HospitalDataViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "HospitalDataViewController") as! HospitalDataViewController
            self.revealViewController()?.pushFrontViewController(objHospital, animated: true)
        }
        if indexPath.row == 4 {
            let objLICDisplay:LICDisplayViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LICDisplayViewController") as! LICDisplayViewController
            self.revealViewController()?.pushFrontViewController(objLICDisplay, animated: true)
        }
        if indexPath.row == 5 {
            let objBorrowDetail:BorrowViewController = UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "BorrowViewController") as! BorrowViewController
            self.revealViewController()?.pushFrontViewController(objBorrowDetail, animated: true)
        }
        if indexPath.row == 6 {
            let objSearchDetail:SearchExpnaceViewController = UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchExpnaceViewController") as! SearchExpnaceViewController
            self.revealViewController()?.pushFrontViewController(objSearchDetail, animated: true)
        }
        if indexPath.row == 7 {
            let objEventList:EventListViewController = UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "EventListViewController") as! EventListViewController
            self.revealViewController()?.pushFrontViewController(objEventList, animated: true)
        }
        if indexPath.row == 8 {
            let objProofDisplay:ProofDisplayViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "ProofDisplayViewController") as! ProofDisplayViewController
            self.revealViewController()?.pushFrontViewController(objProofDisplay, animated: true)
        }
        if indexPath.row == 9 {
            //Save QR payer
            let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
            self.revealViewController()?.pushFrontViewController(objSearchProduct, animated: true)
        }
        if indexPath.row == 10 {
            let objProfile:SignUpViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
            objProfile.isFromSignUp = false
            objProfile.updateData = {[weak self] in
            }
            self.revealViewController()?.pushFrontViewController(objProfile, animated: true)
        }
        
        if indexPath.row == 11 {
            let objChangePassword:ChangePasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
            
            self.revealViewController()?.pushFrontViewController(objChangePassword, animated: true)
        }
        if indexPath.row == 12 {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to take back up from icloude?", ok: { (isSuccess) in
                self.moveToLoaderPage(isFromDelete: true)
            }, isCancel: true) { (isFalied) in
            }
        }
        
        if indexPath.row == 13 {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to remove database from icloude and locally, after it you can't be get any data from the app, you have to crate new user?", ok: { (isSuccess) in
                self.moveToLoaderPage(isFromDelete: true)
            }, isCancel: true) { (isFalied) in
            }
        }
        
        if indexPath.row == 14 {
            let alert = UIAlertController(title: kAppName, message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (logout) in
                self.moveToMainPage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func moveToMainPage() {        
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
        self.view.window?.rootViewController = initialViewController
    }
    
    func moveToLoaderPage(isFromDelete:Bool) {
        let viewController = UIStoryboard(name:LIC , bundle: nil).instantiateViewController(identifier: "LoaderNavigation")
        let loaderViewController:LoaderViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LoaderViewController") as! LoaderViewController
        loaderViewController.isFromDelete = isFromDelete
        self.view.window?.rootViewController = viewController
    }
}
