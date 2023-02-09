//
//  LICAddSetailViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit
import SBPickerSelector
import IQKeyboardManagerSwift

class LICAddDetailViewModel: NSObject {
    var arrTitle = ["Member Name","Policy Number","Policy Name","Deduction Amount","Start Date","Payment Type","How many years?","Contact Person","Contact Number"]
    var headerViewXib:CommanView?
    var arrDescription = [String]()
    var arrTotalMonth = [String]()
    var selectedDate:String = ""
    var isFromEdit:Bool = false
    var arrAllMemberName = [String]()
    func setHeaderView(headerView:UIView,isFromEdit:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromEdit {
            headerViewXib!.lblTitle.text = "Edit LIC Details"
        }else {
            headerViewXib!.lblTitle.text = "Add LIC Details"
        }
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LICAddDetailViewController(), action: #selector(LICAddDetailViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
          return formatter
      }()
    private lazy var today: Date = {
             return Date()
         }()
    func setupDescription() {
        arrDescription.removeAll()
        for _ in 0...arrTitle.count - 1 {
            arrDescription.append("")
        }
        arrTotalMonth.removeAll()
        for i in 5...50 {
            arrTotalMonth.append("\(i)")
        }
    }
}
extension LICAddDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objLICAddDetails.arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLICAdd.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.btnSelection.tag = indexPath.row
        cell.txtDescription.tag = indexPath.row
        cell.lblTitle.text = objLICAddDetails.arrTitle[indexPath.row]
        cell.txtDescription.text = objLICAddDetails.arrDescription[indexPath.row]
        if indexPath.row == 3 || indexPath.row == 8 {
            cell.txtDescription.keyboardType = .numberPad
        } else {
            cell.txtDescription.keyboardType = .alphabet
        }
        if indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 5 {
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
            if  cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
            
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
            cell.txtDescription.delegate = self
        }
        cell.selectedIndex = {[weak self] value in
            DispatchQueue.main.async {
                if value == 0  && !self!.isFromEdit{
                    self?.setMemberPicker(selectedIndex: value)
                }
                else if value == 4 {
                    self!.setupPickerView(selectedIndex: value)
                } else if value == 5 {
                    self!.setUpTypePicker(selectedIndex: value)
                }
                else {
                    self!.showAllMonths(selectedIndex: value)
                }
            }
           
        }
        if indexPath.row == 1 && isFromEdit{
            cell.txtDescription.isEnabled = false
        } else {
            cell.txtDescription.isEnabled = true
        }
        if isFromEdit && indexPath.row == 8 {
            cell.btnCall.isHidden = false
        } else {
            cell.btnCall.isHidden = true
        }
        cell.callclicked = {[weak self] in
            self?.callPerson()
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension LICAddDetailViewController: UITextFieldDelegate{
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblLICAdd.reloadData()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objLICAddDetails.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        if textField.tag == objLICAddDetails.arrDescription.count - 1{
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        objLICAddDetails.arrDescription[textField.tag] = textField.text! + string
        return true
    }
}
extension LICAddDetailViewController {
  //  ["Policy Number","Member Name","Deduction Amount","Start Date","Total Months","Contact Person","Contact Number"]
    func setUpAllData() {
        if let name = dicLICdata["name"] {
            objLICAddDetails.arrDescription[0] = name as! String
        }
        if let policyNumber = dicLICdata["policyNumber"] {
            objLICAddDetails.arrDescription[1] = policyNumber as! String
        }
        if let policyNumber = dicLICdata["policyName"] {
            objLICAddDetails.arrDescription[2] = policyNumber as! String
        }
        if let amount = dicLICdata["amount"] {
            objLICAddDetails.arrDescription[3] = amount as! String
        }
        if let date = dicLICdata["date"] {
            objLICAddDetails.arrDescription[4] = date as! String
        }
        if let months = dicLICdata["type"] {
            objLICAddDetails.arrDescription[5] = months as! String
        }
        if let months = dicLICdata["months"] {
            objLICAddDetails.arrDescription[6] = months as! String
        }
        if let personName = dicLICdata["personName"] {
            objLICAddDetails.arrDescription[7] = personName as! String
        }
        if let personNumber = dicLICdata["personNumber"] {
            objLICAddDetails.arrDescription[8] = personNumber as! String
        }
    }
    
    func setupValidation() -> Bool {
        if objLICAddDetails.arrDescription[0] == "" {
            Alert().showAlert(message: "please provide Policy Number", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[1] == "" {
            Alert().showAlert(message: "please provide Policy Name", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[2] == "" {
            Alert().showAlert(message: "please provide Member Name", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[3] == "" {
            Alert().showAlert(message: "please provide  Deduction Amount", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[4] == "" {
            Alert().showAlert(message: "please provide Start Date", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[5] == "" {
            Alert().showAlert(message: "please provide Payment Type", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[6] == "" {
            Alert().showAlert(message: "please provide Total Months", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[7] == "" {
            Alert().showAlert(message: "please provide Contact Person", viewController: self)
            return false
        }
        else if objLICAddDetails.arrDescription[8] == "" {
            Alert().showAlert(message: "please provide Contact Number", viewController: self)
            return false
        }
        else if !validatePhoneNumber(value: objLICAddDetails.arrDescription[8]) {
            Alert().showAlert(message: "please provide 10 digit moblie number", viewController: self)
            return false
        }
        return true
    }
    
    func configureData() {
        self.tblLICAdd.delegate = self
        self.tblLICAdd.dataSource = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
                  viewBtnDisplay.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewBtnDisplay.frame.size.height = (60.0 * (screenWidth/320.0))
              }
        
        btnSave.setUpButton()
        objLICAddDetails.setupDescription()
        if isFromEdit {
            self.setUpAllData()
        }
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.getAllMembers()
    }
    func getAllMembers() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        AllMemberList.shared.getMemberList { (result) in
            DispatchQueue.main.async {
                self.objLICAddDetails.arrAllMemberName = AllMemberList.shared.getNameArray()
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
        
    }
    
    func setMemberPicker(selectedIndex:Int) {
        if self.objLICAddDetails.arrAllMemberName.count <= 0 {
            DispatchQueue.main.async {
                setAlertWithCustomAction(viewController: self, message: kPleaseAddMember, ok: { (isValied) in
                    self.showMember()
                }, isCancel: false) { (isValied) in
                }
            }
        } else {
            IQKeyboardManager.shared.resignFirstResponder()
            PickerView.objShared.setUPickerWithValue(arrData: self.objLICAddDetails.arrAllMemberName, viewController: self) { (selectedMember) in
                self.objLICAddDetails.arrDescription[selectedIndex] = selectedMember
                self.tblLICAdd.reloadData()
            }
        }
    }
    
    func showMember() {
        let objFamilyMember:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
        objFamilyMember.taUpdateMember = { [weak self] value in
            AllMemberList.shared.getMemberList { (result) in
                self!.objLICAddDetails.arrAllMemberName = AllMemberList.shared.getNameArray()
            }
        }
        objFamilyMember.modalPresentationStyle = .overFullScreen
        self.present(objFamilyMember, animated: true, completion: nil)
    }
    
    

    
    func setUpTypePicker(selectedIndex:Int) {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: ["Quarterly","Half Year","Yearly"], viewController: self) { (selectedType) in
            self.objLICAddDetails.arrDescription[selectedIndex] = selectedType
            self.tblLICAdd.reloadData()
        }
    }
    
    func setupPickerView(selectedIndex:Int) {
        let date = Date()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
        }.set { values in
            if let values = values as? [Date] {
                self.objLICAddDetails.arrDescription[selectedIndex] = self.objLICAddDetails.dateFormatter.string(from: values[0])
                self.tblLICAdd.reloadData()
            }
        }.present(into: self)
    }
    
    func showAllMonths(selectedIndex:Int) {
        if self.objLICAddDetails.arrDescription[5].isEmpty {
            Alert().showAlert(message: "please select type of payment", viewController: self)
            return
        }
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: objLICAddDetails.arrTotalMonth, viewController: self) { (seletedValue) in
            self.objLICAddDetails.arrDescription[selectedIndex] = seletedValue
            self.tblLICAdd.reloadData()
        }
    }
    
    func callPerson() {
        self.objLICAddDetails.arrDescription[8].makeACall()
    }
    
    
    func setupallLICDateandAddInDatabase(month:String)  {
        let totalMonth = Int(month)
        var totalCount:Int = 0
        switch objLICAddDetails.arrDescription[5] {
        case "Quarterly":
            totalCount = totalMonth! * 4
            break
        case "Half Year":
            totalCount = totalMonth! * 2
            break
        case "Yearly":
            totalCount = totalMonth!
            break
        default:
            break
        }
        var addMonths:String = "4"
        switch objLICAddDetails.arrDescription[5] {
        case "Quarterly":
            addMonths = "4"
            break
        case "Half Year":
            addMonths = "6"
            break
        case "Yearly":
            addMonths = "12"
            break
        default:
            break
        }
        let date = objLICAddDetails.arrDescription[4]
        for i in 0...totalCount - 1 {
            if  i == 0 {
                objLICAddDetails.selectedDate = date
            } else {
                objLICAddDetails.selectedDate = objAddLoanDetails.countEndDate(strDate: objLICAddDetails.selectedDate, month: addMonths)
            }
            self.scheduleNotification(selectedDate: objLICAddDetails.selectedDate)
            _ = objLICEntryPerMonthQuery.saveEntryDetails(policyNumber: objLICAddDetails.arrDescription[1], date:objLICAddDetails.selectedDate , amount: objLICAddDetails.arrDescription[3], billNumber: "")
        }
    }
    
    
    func saveDataInDataBase()  -> Bool {
        var dataSaved:Bool = false
   
        if !isFromEdit {
            _ = objAddLoanDetails.countEndDate(strDate: objLICAddDetails.arrDescription[4], month: objLICAddDetails.arrDescription[6])
            dataSaved = objUserLICDetailsQuery.saveLICDetail(name: objLICAddDetails.arrDescription[0], policyNumber: objLICAddDetails.arrDescription[1], date: objLICAddDetails.arrDescription[4], months: objLICAddDetails.arrDescription[6], amount: objLICAddDetails.arrDescription[3], personName: objLICAddDetails.arrDescription[7], personNumber: objLICAddDetails.arrDescription[8],policyName: objLICAddDetails.arrDescription[2], type: objLICAddDetails.arrDescription[5])
            self.setupallLICDateandAddInDatabase(month: objLICAddDetails.arrDescription[6])
        } else {
            objUserLICDetailsQuery.updateLICDetails(name: objLICAddDetails.arrDescription[0], policyNumber: objLICAddDetails.arrDescription[1], date: objLICAddDetails.arrDescription[4], months: objLICAddDetails.arrDescription[6], amount: objLICAddDetails.arrDescription[3], personName: objLICAddDetails.arrDescription[7], personNumber: objLICAddDetails.arrDescription[8], policyName: objLICAddDetails.arrDescription[2]) { (isSuccess) in
            }

        }
        
        return dataSaved
    }
    
    //MARK:- Set up Local Notification
    func scheduleNotification(selectedDate: String) {
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let categoryIdentifire = "Delete Notification Type"
        content.title = "Reminder"
        content.body = "This is reminder for the loan "
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
        let myString = formatter.string(from: Date())
        let convertedDate = convertDateWithTime(date: myString, hour: 0, minutes: 0)
        let eventDate = convertDateWithTime(date: selectedDate, hour: 10, minutes: 30)
        var timeInterval = TimeInterval()
        timeInterval = convertedDate.timeIntervalSince(eventDate)
        if timeInterval < 0 {
            timeInterval = eventDate.timeIntervalSince(convertedDate)
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let formatter1 = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter1.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
        let myString1 = formatter1.string(from: eventDate)
        let identifier = "Local Notification" + myString1
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                Alert().showAlert(message: "Error \(error.localizedDescription)", viewController: self)
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
