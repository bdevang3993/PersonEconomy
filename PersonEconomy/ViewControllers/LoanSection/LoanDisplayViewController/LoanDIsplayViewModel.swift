//
//  LoanDIsplayViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit
import Floaty
class LoanDIsplayViewModel: NSObject {
    
    var strConvertedDate:String = ""
    var arrLoanDescription = [[String:Any]]()
    var isShowDetail:Bool = false
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Loan Section"
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
extension LoanDisplayViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return objLoanDisplayViewModel.arrLoanDescription.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 80
            } else {
                return 60
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 80
            } else {
                return 50
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayLoan.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            
            let cell = tblDisplayLoan.dequeueReusableCell(withIdentifier: "LoanHeaderTableViewCell") as! LoanHeaderTableViewCell
            let objData = objLoanDisplayViewModel.arrLoanDescription[indexPath.row]
            cell.TypeofLoan.text = (objData["loanTYpe"] as! String)
            cell.lblStartDate.text = (objData["startDate"] as! String)
            cell.lblEndDate.text = (objData["endDate"] as! String)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objLoanDisplayViewModel.isShowDetail {
            self.movetoShowLoanDetail(index: indexPath.row)
            objLoanDisplayViewModel.isShowDetail = false
        }
        else {
            if indexPath.section == 1 {
                let objLoanDetails:LoanDetailsViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "LoanDetailsViewController") as! LoanDetailsViewController
                let objData = objLoanDisplayViewModel.arrLoanDescription[indexPath.row]
                objLoanDetails.strLoanId = objData["loanId"] as! String
                objLoanDetails.strBankName = objData["bankName"] as! String
                objLoanDetails.modalPresentationStyle = .overFullScreen
                objLoanDetails.updatedata = { [weak self] in
                    DispatchQueue.main.async {
                        self?.getDatafromDataBase()
                    }
                }
                self.present(objLoanDetails, animated: true, completion: nil)
            }
        }
     
    }
}
extension LoanDisplayViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add Loan Details", icon: UIImage(named: "loan")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to add Loan Details?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                    self.moveToAddLoan()
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
        floaty.addItem("Loan detail", icon: UIImage(named: "loan")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to check Loan Detail?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                    self.showAlertLoanDisplay()
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
        self.view.addSubview(floaty)
    }
}
extension LoanDisplayViewController {
    
    func getDatafromDataBase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objLoanDisplayViewModel.arrLoanDescription.removeAll()
        objLoanDetails.fetchData { (result) in
            self.objLoanDisplayViewModel.arrLoanDescription = result
            self.tblDisplayLoan.reloadData()
            MBProgressHub.dismissLoadingSpinner(self.view)
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
        
    }
    func moveToAddLoan() {
        let objAddLoan:AddLoanDetailViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "AddLoanDetailViewController") as! AddLoanDetailViewController
       // objAddLoan.dicLoanDetails = objLoanDisplayViewModel.arrLoanDescription[0]
        objAddLoan.updateData = {[weak self] in
            DispatchQueue.main.async {
                self!.getDatafromDataBase()
            }
        }
        objAddLoan.modalPresentationStyle = .overFullScreen
        self.present(objAddLoan, animated: true, completion: nil)
    }
    func movetoShowLoanDetail(index:Int) {
        let objAddLoan:AddLoanDetailViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "AddLoanDetailViewController") as! AddLoanDetailViewController
        objAddLoan.dicLoanDetails = objLoanDisplayViewModel.arrLoanDescription[index]
        objAddLoan.isFromLonaDetails = true
        objAddLoan.updateData = {[weak self] in
            DispatchQueue.main.async {
                self!.getDatafromDataBase()
            }
        }
        objAddLoan.modalPresentationStyle = .overFullScreen
        self.present(objAddLoan, animated: true, completion: nil)
    }
    func showAlertLoanDisplay() {
        setAlertWithCustomAction(viewController: self, message: "Are you sure you want to see Loan Detail please select the entry?", ok: { (success) in
            self.objLoanDisplayViewModel.isShowDetail = true
        }, isCancel: false) { (failed) in
            
        }
    }
}
