//
//  AddMediclamViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 13/03/21.
//

import UIKit
import IQKeyboardManagerSwift

class AddMediclamViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrTitle = ["Member Name","Mediclam Number","Start Date","End Date","Agent Name","Agent Number","Mediclam Name","Mediclam Amount"]
    var arrDescription = ["","","","","","","",""]
    var mediclamId:Int = 0
    var isFromEditMediclam:Bool = false
    var arrMemberName = [String]()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromEditMediclam {
            headerViewXib!.lblTitle.text = "Edit Mediclam"
        }else {
            headerViewXib!.lblTitle.text = "Add Mediclam"
        }
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddMedicalmViewController(), action: #selector(AddMedicalmViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension AddMedicalmViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddMedicalmViewModel.arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblAddData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.lblTitle.text = objAddMedicalmViewModel.arrTitle[indexPath.row]
        cell.txtDescription.text = objAddMedicalmViewModel.arrDescription[indexPath.row]
        cell.btnSelection.tag = indexPath.row
        cell.txtDescription.delegate = self
        cell.txtDescription.tag = indexPath.row
        if cell.lblTitle.text == "Agent Number" || cell.lblTitle.text == "Mediclam Amount" {
            cell.txtDescription.keyboardType = .numberPad
        } else {
            cell.txtDescription.keyboardType = .alphabet
        }
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 {
            if  cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
        }
        else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
            cell.txtDescription.delegate = self
        }
        if self.isFromEdit && indexPath.row == 0 {
            cell.btnSelection.isEnabled = false
            cell.txtDescription.isEnabled = false
            cell.imgDown.isHidden = true
        }
        if self.isFromEdit && cell.lblTitle.text == "Mediclam Number" {
            cell.txtDescription.isEnabled = false
        }
        cell.selectedIndex = {[weak self] value in
            DispatchQueue.main.async {
                if value == 0 {
                    self?.pickerForMemberName(index: value)
                }
                if value == 2 {
                    self?.pickDate(index: value)
                }
                if value == 3 {
                    self?.pickDate(index: value)
                }
            }
        }
        cell.btnCall.isHidden = true
        if isFromEdit {
            if indexPath.row == 5 {
                cell.btnCall.isHidden = false
            } else {
                cell.btnCall.isHidden = true
            }
        }
        cell.callclicked = {[weak self] in
            self!.callUser()
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension AddMedicalmViewController {
    func configureData() {
        if UIDevice.current.userInterfaceIdiom == .pad {
                  viewbtnSubmit.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewbtnSubmit.frame.size.height = (60.0 * (screenWidth/320.0))
              }
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        objAddMedicalmViewModel.isFromEditMediclam = isFromEdit
        objAddMedicalmViewModel.setHeaderView(headerView: self.viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblAddData.delegate = self
        self.tblAddData.dataSource = self
        btnSave.setUpButton()
        if isFromEdit {
            self.btnDelete.isHidden = false
            self.setAllValue()
        } else {
            self.btnDelete.isHidden = true
            self.getMemberId()
            self.getAllMemberName()
        }
    }
    
    func setAllValue() {
        if let memberName = dicMediclamData["memberName"] {
            objAddMedicalmViewModel.arrDescription[0] = memberName as! String
        }
        if let policyNumber = dicMediclamData["policyNumber"] {
            objAddMedicalmViewModel.arrDescription[1] = policyNumber as! String
        }
        if let startDate = dicMediclamData["startDate"] {
            objAddMedicalmViewModel.arrDescription[2] = startDate as! String
        }
        if let endDate = dicMediclamData["endDate"] {
            objAddMedicalmViewModel.arrDescription[3] = endDate as! String
        }
        if let agentName = dicMediclamData["agentName"] {
            objAddMedicalmViewModel.arrDescription[4] = agentName as! String
        }
        if let agentNumber = dicMediclamData["agentNumber"] {
            objAddMedicalmViewModel.arrDescription[5] = agentNumber as! String
        }
        if let type = dicMediclamData["type"] {
            objAddMedicalmViewModel.arrDescription[6] = type as! String
        }
        if let amount = dicMediclamData["price"] {
            objAddMedicalmViewModel.arrDescription[7] = amount as! String
        }
        if let memberId = dicMediclamData["memberId"] {
            objAddMedicalmViewModel.mediclamId = Int(memberId as! String)!
        }
    }
    func setValidation() -> Bool{
        if objAddMedicalmViewModel.arrDescription[0].isEmpty {
            Alert().showAlert(message: "please select member name", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[1].isEmpty {
            Alert().showAlert(message: "please provie policy number", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[2].isEmpty {
            Alert().showAlert(message: "please select  start date", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[3].isEmpty {
            Alert().showAlert(message: "please select end date", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[4].isEmpty {
            Alert().showAlert(message: "please provide agent name", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[5].isEmpty {
            Alert().showAlert(message: "please provide agent number", viewController: self)
            return false
        }
        if !validatePhoneNumber(value: objAddMedicalmViewModel.arrDescription[5]) {
            Alert().showAlert(message: "please provide 10 digit mobile number", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[6].isEmpty {
            Alert().showAlert(message: "please provide mediclam name", viewController: self)
            return false
        }
        if objAddMedicalmViewModel.arrDescription[7].isEmpty {
            Alert().showAlert(message: "please provide mediclam amount", viewController: self)
            return false
        }
        return true
    }
    func pickerForMemberName(index:Int) {
        if objAddMedicalmViewModel.arrMemberName.count <= 0 {
            DispatchQueue.main.async {
                setAlertWithCustomAction(viewController: self, message: kPleaseAddMember, ok: { (isValied) in
                    self.showMember()
                }, isCancel: false) { (isValied) in
                }
            }
        } else {
            IQKeyboardManager.shared.resignFirstResponder()
            PickerView.objShared.setUPickerWithValue(arrData: objAddMedicalmViewModel.arrMemberName, viewController: self) { (value) in
                self.objAddMedicalmViewModel.arrDescription[index] = value
                self.tblAddData.reloadData()
            }
        }
    }

    func showMember() {
        let objFamilyMember:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
        objFamilyMember.taUpdateMember = { [weak self] value in
            AllMemberList.shared.getMemberList { (result) in
                self!.objAddMedicalmViewModel.arrMemberName = AllMemberList.shared.getNameArray()
            }
        }
        objFamilyMember.modalPresentationStyle = .overFullScreen
        self.present(objFamilyMember, animated: true, completion: nil)
    }
    
    
    
    func pickDate(index:Int) {
        PickerView.objShared.setUpDatePickerWithoutEndDate(viewController: self) { (selectedValue) in
            let strSelectedvalue:String = self.dateFormatter.string(from: selectedValue)
            self.objAddMedicalmViewModel.arrDescription[index] = strSelectedvalue
            self.tblAddData.reloadData()
        }
    }
    func callUser() {
        objAddMedicalmViewModel.arrDescription[5].makeACall()
    }
}
//MARK:- Database Query

extension AddMedicalmViewController {
    func getAllMemberName() {
        AllMemberList.shared.getMemberList { (result) in
            self.objAddMedicalmViewModel.arrMemberName = AllMemberList.shared.getNameArray()
        }
        
    }
    func getMemberId() {
        objUserMediclamDB.getRecordsCount { (count) in
            self.objAddMedicalmViewModel.mediclamId = count + 1
        }
    }
    func saveMediclamData() {
        let dataSaved = objUserMediclamDB.saveinDataBase(memberId: "\(objAddMedicalmViewModel.mediclamId)", memberName: objAddMedicalmViewModel.arrDescription[0], policyNumber: objAddMedicalmViewModel.arrDescription[1], startDate: objAddMedicalmViewModel.arrDescription[2], endDate: objAddMedicalmViewModel.arrDescription[3], agentName: objAddMedicalmViewModel.arrDescription[4], agentNumber: objAddMedicalmViewModel.arrDescription[5], type: objAddMedicalmViewModel.arrDescription[6], price: objAddMedicalmViewModel.arrDescription[7])
        if dataSaved {
            self.scheduleNotification(selectedDate: objAddMedicalmViewModel.arrDescription[3])
            setAlertWithCustomAction(viewController: self, message: "Data Saved", ok: { (success) in
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (failed) in
            }
        }
    }
    func updateMediclamData() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMediclamDB.updatemediclamDetail(policyNumber: objAddMedicalmViewModel.arrDescription[1], startDate: objAddMedicalmViewModel.arrDescription[2], endDate: objAddMedicalmViewModel.arrDescription[3], agentName: objAddMedicalmViewModel.arrDescription[4], agentNumber: objAddMedicalmViewModel.arrDescription[5], type: objAddMedicalmViewModel.arrDescription[6]) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Data Updated", ok: { (success) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    
    func deleteMediclamData() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMediclamDB.deleteMediclamDetail(memberId: "\(objAddMedicalmViewModel.mediclamId)") { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Deleted Successfully", ok: { (isSuccess) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isFailed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    
    //MARK:- Set up Local Notification
    func scheduleNotification(selectedDate: String) {
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let categoryIdentifire = "Set Notification Type"
        content.title = "Reminder"
        content.body = "This is reminder for the Mediclam Reminder"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
        let myString = formatter.string(from: Date())
        let convertedDate = convertDateWithTime(date: myString, hour: 0, minutes: 0)
        let eventDate = convertDateWithTime(date: selectedDate, hour: 10, minutes: 30)
        var timeInterval = convertedDate.timeIntervalSince(eventDate)
        if timeInterval < 0  {
            timeInterval = eventDate.timeIntervalSince(convertedDate)
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let formatter1 = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter1.dateFormat = "dd/MM/yyyy"
        let myString1 = formatter1.string(from: eventDate)
        let identifier = "Local Notification" + myString1
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                Alert().showAlert(message: error.localizedDescription, viewController: self)
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        appDelegate.notificationCenter.setNotificationCategories([category])
    }
}

extension AddMedicalmViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblAddData.reloadData()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                let value = textField.text?.dropLast()
                objAddMedicalmViewModel.arrDescription[textField.tag] = String(value!)
                return true
            }
        }
        if textField.tag == objAddMedicalmViewModel.arrDescription.count - 3{
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        objAddMedicalmViewModel.arrDescription[textField.tag] = textField.text! + string
        return true
    }
}
