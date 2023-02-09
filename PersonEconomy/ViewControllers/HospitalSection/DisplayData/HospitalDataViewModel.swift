//
//  HospitalDataViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 10/02/21.
//

import UIKit
import Floaty
class HospitalDataViewModel: NSObject {
    
    var arrAllHospitalData = [[String:Any]]()
    
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Hospital Section"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LoanDisplayViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }

}
extension HospitalDataViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
           return 80
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return objHospitalDataViewModel.arrAllHospitalData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HospitalDataTableViewCell") as! HospitalDataTableViewCell
            let objHospitalData = objHospitalDataViewModel.arrAllHospitalData[indexPath.row]
            if let memberName = objHospitalData["memberName"] {
                cell.lblName.text =  (memberName as! String)
            }
            if let hospitalName = objHospitalData["hospitalName"] {
                cell.lblHospitalName.text =  (hospitalName as! String)
            }
            if let amount = objHospitalData["amount"] {
                cell.lblPrice.text =  (amount as! String)
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let objAddHospital:AddHospitalViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "AddHospitalViewController") as! AddHospitalViewController
            objAddHospital.objHospitalData = objHospitalDataViewModel.arrAllHospitalData[indexPath.row]
            objAddHospital.isFromEditHospital = true
            objAddHospital.modalPresentationStyle = .overFullScreen
            objAddHospital.updateData = {[weak self] in
                DispatchQueue.main.async {
                    self?.getDatafromDataBase()
                }
            }
            self.present(objAddHospital, animated: true, completion: nil)
        }
    }
}



extension HospitalDataViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add Hospital Details", icon: UIImage(named: "hospital")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to add Hospital Details?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                    self.moveToAddHospitalData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        floaty.addItem("Add Mediclam", icon: UIImage(named: "mediclaim")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to add Mediclam Details?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                    self.moveToAddMediclam()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        floaty.addItem("Display Mediclam", icon: UIImage(named: "mediclaim")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to display Mediclam Details?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                    self.moveToDisplayMediclam()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        self.view.addSubview(floaty)
    }
}
extension HospitalDataViewController {
    func getDatafromDataBase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMedicalQuery.fetchData { (result) in
            self.objHospitalDataViewModel.arrAllHospitalData = result
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.tblDisplayData.reloadData()
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func moveToAddHospitalData() {
        let objAddHospital:AddHospitalViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "AddHospitalViewController") as! AddHospitalViewController
        objAddHospital.updateData = {[weak self] in
            DispatchQueue.main.async {
                self?.getDatafromDataBase()
            }
        }
        objAddHospital.modalPresentationStyle = .overFullScreen
        self.present(objAddHospital, animated: true, completion: nil)
    }
    func moveToDisplayMediclam() {
        let objDisplayMediclam:MedicalmDisplayViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "MedicalmDisplayViewController") as! MedicalmDisplayViewController
        objDisplayMediclam.modalPresentationStyle = .overFullScreen
        self.present(objDisplayMediclam, animated: true, completion: nil)
    }
    func moveToAddMediclam() {
        let objAddMediclam:AddMedicalmViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "AddMedicalmViewController") as! AddMedicalmViewController
        objAddMediclam.modalPresentationStyle = .overFullScreen
        self.present(objAddMediclam, animated: true, completion: nil)
    }
    
    func setConfigureData() {
        self.getDatafromDataBase()
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.layoutFAB()
    
    }
   
}
