//
//  AddHospitalViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 12/02/21.
//

import UIKit
import SBPickerSelector
import IQKeyboardManagerSwift

class AddHospitalViewModel: NSObject {
    var arrTitle = ["Member Name","Admitted Date","Discharge Date","Hospital Name","Return from Mediclam","Contact person name","Contact Number","Total Amount","Mediclame Type"]//
    var arrDescription = ["","","","","","","","",""]
    var headerViewXib:CommanView?
    var isFromEditHospital:Bool = false
    var medicalId:Int = 0
    var arrTotalMonth = [String]()
    var arrAllMemberName = [String]()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromEditHospital {
            headerViewXib!.lblTitle.text = "Edit Hospital Details"
            headerViewXib!.btnHeader.isHidden = false
        }else {
            headerViewXib!.lblTitle.text = "Add Hospital Details"
            headerViewXib!.btnHeader.isHidden = true
        }
        headerViewXib!.btnHeader.setTitle("Add Bill", for: .normal)
        headerViewXib!.btnHeader.addTarget(AddHospitalViewController(), action: #selector(AddHospitalViewController.moveToAddBill), for: .touchUpInside)
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddHospitalViewController(), action: #selector(AddHospitalViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func setAllMonth() {
        arrTotalMonth.removeAll()
        for i in 0...500 {
            arrTotalMonth.append("\(i)")
        }
    }
}
extension AddHospitalViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddHospital.arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.lblTitle.text = objAddHospital.arrTitle[indexPath.row]
        cell.txtDescription.text = objAddHospital.arrDescription[indexPath.row]
        cell.btnSelection.tag = indexPath.row
        if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 8 {
            cell.txtDescription.isEnabled = false
        }
        else {
            cell.txtDescription.isEnabled = true
            cell.txtDescription.tag = indexPath.row
        }
        if indexPath.row == 7 {
            cell.txtDescription.keyboardType = .decimalPad
        }
        else {
            cell.txtDescription.keyboardType = .alphabet
        }
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4{
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
            if cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
            cell.selectedIndex = {[weak self] value in
                DispatchQueue.main.async {
                    if value == 0  && !self!.isFromEditHospital{
                        self?.setMemberName(selectedIndex: value)
                    }
                    else if value == 4 {
                        self?.setupPickerData(selectedIndex: value)
                    } else {
                        self?.setupPickerDate(selectedIndex: value)
                    }
                }
            }
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
            cell.txtDescription.delegate = self
        }
        cell.btnCall.isHidden = true
        if isFromEditHospital {
            if indexPath.row == 6  && objAddHospital.arrDescription[6].count > 0 {
                cell.btnCall.isHidden = false
            } else {
                cell.btnCall.isHidden = true
            }
        }
        cell.callclicked = { [weak self] in
            self?.makeCall()
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension AddHospitalViewController: UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objAddHospital.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        if textField.tag == 6 {
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        objAddHospital.arrDescription[textField.tag] = textField.text! + string
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblDisplayData.reloadData()
        return true
    }
}
extension AddHospitalViewController {
    func setConfigureData() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
                  viewbtnSubmit.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewbtnSubmit.frame.size.height = (60.0 * (screenWidth/320.0))
              }
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        objAddHospital.isFromEditHospital = isFromEditHospital
        objAddHospital.setHeaderView(headerView: viewHeader)
        if isFromEditHospital {
            self.btnDelete.isHidden = false
            self.updateDataInTextField()
        } else {
            self.btnDelete.isHidden = true
            self.getLastId()
        }
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.btnSave.setUpButton()
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.getAllMembers()
    }
    
    func getAllMembers() {
        DispatchQueue.main.async {
            MBProgressHub.showLoadingSpinner(sender: self.view)
            AllMemberList.shared.getMemberList { (result) in
                self.objAddHospital.arrAllMemberName = AllMemberList.shared.getNameArray()
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                }
            }
        }
         
    }
    func setMemberName(selectedIndex:Int) {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: objAddHospital.arrAllMemberName, viewController: self) { (selectedMember) in
            self.objAddHospital.arrDescription[selectedIndex] = selectedMember
            self.getMediclamDetails(name: selectedMember)
            self.tblDisplayData.reloadData()
        }
    }
    
    func setupPickerDate(selectedIndex:Int) {
        let date = Date()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
        }.set { values in
            if let values = values as? [Date] {
                
                self.objAddHospital.arrDescription[selectedIndex] = self.dateFormatter.string(from: values[0])
                //self.txtBirthDay.text = values[0]
                self.tblDisplayData.reloadData()
            }
        }.present(into: self)
    }

    func setupPickerData(selectedIndex:Int) {
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: ["Yes","No"]).cancel {
            }.set { values in
                if let values = values as? [String] {
                    //self.objExpenseViewModel.arrDescription[2] = values[0]
                    self.objAddHospital.arrDescription[selectedIndex] = values[0]
                    self.tblDisplayData.reloadData()
                }
        }.present(into: self)
    }

  
    func setVerification() -> Bool {
        if objAddHospital.arrDescription[0].isEmpty {
            Alert().showAlert(message: "Please provide member Name", viewController: self)
            return false
        }
        else if objAddHospital.arrDescription[1].isEmpty {
            Alert().showAlert(message: "Please provide admitted Date", viewController: self)
            return false
        }
        else if objAddHospital.arrDescription[2].isEmpty {
            Alert().showAlert(message: "Please provide discharge Date", viewController: self)
            return false
        }
        else if objAddHospital.arrDescription[3].isEmpty {
            Alert().showAlert(message: "Please provide hospital name", viewController: self)
            return false
        }
        else if objAddHospital.arrDescription[7].isEmpty {
            Alert().showAlert(message: "Please provide total amount", viewController: self)
            return false
        }
        else if objAddHospital.arrDescription[6].count > 2 {
            if !validatePhoneNumber(value: objAddHospital.arrDescription[6]) {
                Alert().showAlert(message: "please provide valied phone number", viewController: self)
                return false
            }
        }
        return true
    }
    
    func updateDataInTextField() {
        if let hospitalName = objHospitalData["userMedicalId"] {
            objAddHospital.medicalId = Int(hospitalName as! String)!
        }
        if let memberName = objHospitalData["memberName"] {
            objAddHospital.arrDescription[0] = memberName as! String
        }
        if let admittedDate = objHospitalData["admittedDate"] {
            objAddHospital.arrDescription[1] = admittedDate as! String
        }
        if let dischargeDate = objHospitalData["dischargeDate"] {
            objAddHospital.arrDescription[2] = dischargeDate as! String
        }
        if let hospitalName = objHospitalData["hospitalName"] {
            objAddHospital.arrDescription[3] = hospitalName as! String
        }
        if let mediclamGet = objHospitalData["mediclamGet"] {
            objAddHospital.arrDescription[4] = mediclamGet as! String
        }
        if let contactPerson = objHospitalData["contactPerson"] {
            objAddHospital.arrDescription[5] = contactPerson as! String
        }
        if let contactNumber = objHospitalData["contactNumber"] {
            objAddHospital.arrDescription[6] = contactNumber as! String
        }
        if let amount = objHospitalData["amount"] {
            objAddHospital.arrDescription[7] = amount as! String
        }
        if let mediclamType = objHospitalData["mediclamType"] {
            objAddHospital.arrDescription[8] = mediclamType as! String
        }
        tblDisplayData.reloadData()
    }
    
    func setUpMonthPicker(index:Int) {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: objAddHospital.arrTotalMonth, viewController: self) { (selectedValue) in
            self.objAddHospital.arrDescription[index] = selectedValue
        }
    }
    
    func makeCall() {
        objAddHospital.arrDescription[6].makeACall()
    }
}
//MARK:- Database set up
extension AddHospitalViewController {
    
    func getLastId() {
        objUserMedicalQuery.getRecordsCount { (record) in
            self.objAddHospital.medicalId = record + 1
        }
    }
    func getMediclamDetails(name:String) {
        DispatchQueue.main.async {
            MBProgressHub.showLoadingSpinner(sender: self.view)
            self.objUserMediclamDB.fetchMediclamByName(memberName: name) { (result) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                if result.count > 0 {
                    let dicData = result[0]
                    self.objAddHospital.arrDescription[5] = dicData["agentName"] as! String
                    self.objAddHospital.arrDescription[6] = dicData["agentNumber"] as! String
                    self.objAddHospital.arrDescription[8] = dicData["type"] as! String
                    self.tblDisplayData.reloadData()
                } else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "If you have mediclam then please add in mediclam section from the + add mediclam", viewController: self)
                }
            } failure: { (isFailed) in
            }
        }
    }
    func saveInDataBase() {
        let isAdded = objUserMedicalQuery.saveinDataBase(admittedDate: objAddHospital.arrDescription[1], amount: objAddHospital.arrDescription[7], contactNumber: objAddHospital.arrDescription[6], contactPerson: objAddHospital.arrDescription[5], dischargeDate: objAddHospital.arrDescription[2], mediclamGet: objAddHospital.arrDescription[4], mediclamType: objAddHospital.arrDescription[8], memberName: objAddHospital.arrDescription[0], hospitalName: objAddHospital.arrDescription[3], userMedicalId: "\(objAddHospital.medicalId)")
        if isAdded {
            setAlertWithCustomAction(viewController: self, message: "Data saved", ok: { (isSucess) in
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isSucess) in
            }
        }
    }
    
    func updateInDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMedicalQuery.updateMember(admittedDate: objAddHospital.arrDescription[1], amount: objAddHospital.arrDescription[7], contactNumber: objAddHospital.arrDescription[6], contactPerson: objAddHospital.arrDescription[5], dischargeDate: objAddHospital.arrDescription[2], mediclamGet:  objAddHospital.arrDescription[4], mediclamType: objAddHospital.arrDescription[8], memberName: objAddHospital.arrDescription[0], hospitalName: objAddHospital.arrDescription[3], userMedicalId: "\(objAddHospital.medicalId)") { (isSuccess) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            setAlertWithCustomAction(viewController: self, message: "Databae updated succesfully", ok: {value in
                if value == true {
                    self.updateData!()
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false, cancel: {value in
                MBProgressHub.dismissLoadingSpinner(self.view)
            })
        }
    }
    
    func deleteFromDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMedicalQuery.deleteMedicalDetail(userMedicalId: "\(objAddHospital.medicalId)") { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Deleted Data", ok: { (success) in
                if success {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.updateData!()
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
}
