//
//  LoanDescriptionViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 27/01/21.
//

import UIKit
import SBPickerSelector

class LoanDescriptionViewModel: NSObject {
    var arrDisplayData = ["Deduction Date","Deduction Amount","Transaction Id","Bank Name","Agent Name","Agent Number","Paied Date"]
    var arrDescription = ["","","","","","",""]
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView,isfromSignUp:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Loan Description"
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LoanDescriptionViewController(), action: #selector(LoanDescriptionViewController.backCliked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension LoanDescriptionViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objLoanDescription.arrDisplayData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        let strName = objLoanDescription.arrDisplayData[indexPath.row]
        cell.lblTitle.text = strName
        cell.txtDescription.tag = indexPath.row
        cell.txtDescription.text = objLoanDescription.arrDescription[indexPath.row]
        cell.btnSelection.tag = indexPath.row
        if strName == "Paied Date" {
            if  cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
            cell.imgDown.isHidden = false
            cell.btnSelection.isHidden = false
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
        }
        if strName == "Deduction Amount" ||  strName == "Bank Name" || strName == "Agent Name" || strName == "Agent Number" || strName == "Deduction Date" {
            cell.txtDescription.isEnabled = false
        }else {
            cell.txtDescription.isEnabled = true
            cell.txtDescription.delegate = self
        }
        if strName == "Agent Number" {
            cell.btnCall.isHidden = false
        } else {
            cell.btnCall.isHidden = true
        }
        cell.callclicked = {[weak self]  in
            self?.callAgent()
        }
        cell.selectedIndex = {[weak self] value in
            self?.setupPickerDate(selectedIndex: value)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
extension LoanDescriptionViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblDisplayData.reloadData()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objLoanDescription.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        objLoanDescription.arrDescription[textField.tag] = textField.text! + string
        return true
    }


}
extension LoanDescriptionViewController {
    func configureData() {
        if UIDevice.current.userInterfaceIdiom == .pad {
                  viewBtnSubmit.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewBtnSubmit.frame.size.height = (60.0 * (screenWidth/320.0))
              }
        
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        btnSave.setUpButton()
        objLoanDescription.arrDescription[0] = arrLoanDetails["date"] as! String
        objLoanDescription.arrDescription[1] = arrLoanDetails["amount"] as! String
        objLoanDescription.arrDescription[2] = arrLoanDetails["transactionId"] as! String
        objLoanDescription.arrDescription[3] = strBankName
        objLoanDescription.arrDescription[6] = arrLoanDetails["payedDate"] as! String
    }
    func callAgent() {
        objLoanDescription.arrDescription[5].makeACall()
    }
    func fetchLoanDetail() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserLoanDetailsQuery.fetchDataByLoanId(loanId: arrLoanDetails["loanId"] as! String) { (data) in
            if data.count > 0 {
                let newData = data[0]
                if let name = newData["contactPerson"] {
                    self.objLoanDescription.arrDescription[4] = name as! String
                }
                if let number = newData["referenceNumber"] {
                    self.objLoanDescription.arrDescription[5] = number as! String
                }
                self.tblDisplayData.reloadData()
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
        
    }
    
    func setupPickerDate(selectedIndex:Int) {
        let date = Date()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
        }.set { values in
            if let values = values as? [Date] {
                self.objLoanDescription.arrDescription[selectedIndex] = self.dateFormatter.string(from: values[0])
                self.tblDisplayData.reloadData()
            }
        }.present(into: self)
    }
    
    func updateAllData() -> Bool {
      if objLoanDescription.arrDescription[1] == "" {
            Alert().showAlert(message: "Please provide deduction amount", viewController: self)
            return false
        } else if objLoanDescription.arrDescription[2] == "" {
            Alert().showAlert(message: "Please provide transaction Id", viewController: self)
            return false
        }else if objLoanDescription.arrDescription[3] == "" {
            Alert().showAlert(message: "Please provide bank name", viewController: self)
            return false
        } else   if objLoanDescription.arrDescription[6] == "" {
            Alert().showAlert(message: "Please provide deduction date", viewController: self)
            return false
        }
        return true
    }
    
    func updateInDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objLoanEntry_PerMonthQuery.updateEntryDetails(loanId: arrLoanDetails["date"] as! String, date: objLoanDescription.arrDescription[0], amount: objLoanDescription.arrDescription[1], transactionId: objLoanDescription.arrDescription[2], payedDate: objLoanDescription.arrDescription[6]) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Data updated successfully", ok: { (isSuccess) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.clUpdateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isSuccess) in
            }
        }
    }
    
}
