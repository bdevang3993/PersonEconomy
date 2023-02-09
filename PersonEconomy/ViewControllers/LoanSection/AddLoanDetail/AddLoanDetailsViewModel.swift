//
//  AddLoanDetailsViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit
import SBPickerSelector
import IQKeyboardManagerSwift

class AddLoanDetailsViewModel: NSObject {
    var headerViewXib:CommanView?
    var isFromLonaDetails:Bool = false
    var arrNameList = [String]()
    var arrTitle = ["Member Name","Loan Type","Loan ID","Deduction Amount","StartDate","Total Months","Total Amount","Bank Name","Contact Person","Contact Number"]
    var arrDescription = [String]()
    var arrTotalMonth = [String]()
    var selectedDate:String = ""
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
        for i in 0...240 {
            arrTotalMonth.append("\(i)")
        }
    }
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromLonaDetails {
            headerViewXib!.lblTitle.text = "Loan Details"
        }else {
            headerViewXib!.lblTitle.text = "Add Loan Details"
        }
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddLoanDetailViewController(), action: #selector(AddLoanDetailViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func countEndDate(strDate:String,month:String) -> String {
        
        let isoDate = strDate//"2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from:isoDate)!
        var dateComponent = DateComponents()
        let totalMonts = Int(month)
        let year = totalMonts!/12
        let newMonth = totalMonts! % 12
        dateComponent.year = year
        dateComponent.month = newMonth
        let futureDate = date.addMonth(n: totalMonts!)
        let newDate = dateFormatter.string(from: futureDate)
        return newDate
    }
    
}
extension AddLoanDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddLoanDetails.arrTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLoanDescription.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.txtDescription.tag = indexPath.row
        cell.lblTitle.text = objAddLoanDetails.arrTitle[indexPath.row]
        cell.txtDescription.text = objAddLoanDetails.arrDescription[indexPath.row]
        cell.btnSelection.tag = indexPath.row
        if cell.lblTitle.text == "StartDate" || cell.lblTitle.text == "Total Months" || cell.lblTitle.text == "Member Name" {
            if  cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
            cell.txtDescription.delegate = self
        }
        if isFromLonaDetails {
            cell.txtDescription.isEnabled = false
            cell.btnSelection.isEnabled = false
        } else {
            cell.txtDescription.isEnabled = true
            cell.btnSelection.isEnabled = true
        }
        if cell.lblTitle.text == "Contact Number" || cell.lblTitle.text == "Deduction Amount" || cell.lblTitle.text == "Total Amount"{
            cell.txtDescription.keyboardType = .numberPad
        } else {
            cell.txtDescription.keyboardType = .alphabet
        }
        cell.selectedIndex = {[weak self] value in
            DispatchQueue.main.async {
                if value == 0  && !self!.isFromLonaDetails {
                    self?.setNamePicker(selectedIndex: value)
                }
                else if value == 5 {
                    self?.setupPickerViewforString(selectedIndex: value)
                } else {
                    self?.setupPickerView(selectedIndex: value)
                }
            }
        }
        if isFromLonaDetails && indexPath.row == 9 {
            cell.btnCall.isHidden = false
        } else {
            cell.btnCall.isHidden = true
        }
        cell.callclicked = {[weak self] in
            self?.setUpCall()
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension AddLoanDetailViewController: UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objAddLoanDetails.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        if textField.tag == self.objAddLoanDetails.arrDescription.count - 1 {
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        objAddLoanDetails.arrDescription[textField.tag] = textField.text! + string
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblLoanDescription.reloadData()
        return true
    }
}
extension AddLoanDetailViewController {
    
    func setMemberName() {
        if arrMemberList.count <= 0 {
            AllMemberList.shared.getMemberList { (result) in
                if arrMemberList.count <= 0 {
                    DispatchQueue.main.async {
                        setAlertWithCustomAction(viewController: self, message: kPleaseAddMember, ok: { (isValied) in
                            self.showMember()
                        }, isCancel: false) { (isValied) in
                        }
                    }
                }
                else {
                    self.objAddLoanDetails.arrNameList = AllMemberList.shared.getNameArray()
                }

            }
        }else {
            objAddLoanDetails.arrNameList = AllMemberList.shared.getNameArray()
        }
    }
    func showMember() {
        let objFamilyMember:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
        objFamilyMember.taUpdateMember = { [weak self] value in
            //AllMemberList.shared.getMemberList()
            AllMemberList.shared.getMemberList { (result) in
                self!.objAddLoanDetails.arrNameList = AllMemberList.shared.getNameArray()
            }
        }
        objFamilyMember.modalPresentationStyle = .overFullScreen
        self.present(objFamilyMember, animated: true, completion: nil)
    }
    
    func setupAllData() {
        if let memberName = dicLoanDetails["memberName"] {
            objAddLoanDetails.arrDescription[0] = memberName as! String
        }
        if let loanType = dicLoanDetails["loanTYpe"] {
            objAddLoanDetails.arrDescription[1] = loanType as! String
        }
        if let loanID = dicLoanDetails["loanId"] {
            objAddLoanDetails.arrDescription[2] = loanID as! String
        }
        if let amount = dicLoanDetails["deductionAmount"] {
            objAddLoanDetails.arrDescription[3] = amount as! String
        }
        if let startDate = dicLoanDetails["startDate"] {
            objAddLoanDetails.arrDescription[4] = startDate as! String
        }
        if let endDate = dicLoanDetails["endDate"] {
            objAddLoanDetails.arrDescription[5] = endDate as! String
        }
        if let totalAmount = dicLoanDetails["totalAmount"] {
            objAddLoanDetails.arrDescription[6] = totalAmount as! String
        }
        if let bankName = dicLoanDetails["bankName"] {
            objAddLoanDetails.arrDescription[7] = bankName as! String
        }
        if let contactPerson = dicLoanDetails["contactPerson"] {
            objAddLoanDetails.arrDescription[8] = contactPerson as! String
        }
        if let contactNumber = dicLoanDetails["referenceNumber"] {
            objAddLoanDetails.arrDescription[9] = contactNumber as! String
        }
    }
    
    func setupallDateandAddInDatabase(month:String)  {
        let totalMonth = Int(month)
        let date = objAddLoanDetails.arrDescription[4]
        for i in 0...totalMonth! - 1 {
            if  i == 0 {
                objAddLoanDetails.selectedDate = date
            } else {
                objAddLoanDetails.selectedDate = objAddLoanDetails.countEndDate(strDate: objAddLoanDetails.selectedDate, month: "1")
            }
            self.scheduleNotification(selectedDate: objAddLoanDetails.selectedDate)
            _ = objLoanEntry.saveEntryDetails(loanId: objAddLoanDetails.arrDescription[2], date: objAddLoanDetails.selectedDate, amount: objAddLoanDetails.arrDescription[3], transactionId: "")
        }
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
    
    
    func setupPickerView(selectedIndex:Int) {
        let date = Date()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
        }.set { values in
            if let values = values as? [Date] {
                self.objAddLoanDetails.arrDescription[selectedIndex] = self.dateFormatter.string(from: values[0])
                self.tblLoanDescription.reloadData()
            }
        }.present(into: self)
    }
    
    func setNamePicker(selectedIndex:Int) {
        if objAddLoanDetails.arrNameList.count <= 0 {
            //AllMemberList.shared.getMemberList()
            AllMemberList.shared.getMemberList { (result) in
                self.objAddLoanDetails.arrNameList = AllMemberList.shared.getNameArray()
                if self.objAddLoanDetails.arrNameList.count <= 0 {
                    setAlertWithCustomAction(viewController: self, message: kPleaseAddMember, ok: { (isValied) in
                        self.showMember()
                    }, isCancel: false) { (isValied) in
                    }
                    return
                }
            }
        }
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: objAddLoanDetails.arrNameList, viewController: self) { (value) in
            self.objAddLoanDetails.arrDescription[selectedIndex] = value
            self.tblLoanDescription.reloadData()
        }
    }
    func setupPickerViewforString(selectedIndex:Int) {
        if self.objAddLoanDetails.arrDescription[3].isEmpty {
            Alert().showAlert(message: "please select Deduction Amount first", viewController: self)
            return
        }
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: objAddLoanDetails.arrTotalMonth).cancel {
            }.set { values in
                if let values = values as? [String] {
                    self.objAddLoanDetails.arrDescription[selectedIndex] = values[0]
                    var price:Int = 0
                    if !self.objAddLoanDetails.arrDescription[3].isEmpty {
                        price = Int(self.objAddLoanDetails.arrDescription[3])!
                    }
                    self.objAddLoanDetails.arrDescription[selectedIndex + 1] = "\(price * Int(values[0])!)"
                    self.tblLoanDescription.reloadData()
                }
        }.present(into: self)
    }
    func setUpCall() {
        objAddLoanDetails.arrDescription[objAddLoanDetails.arrDescription.count - 1].makeACall()
    }
    
    
    func setupValidation() -> Bool {
         if objAddLoanDetails.arrDescription[0] == "" {
            Alert().showAlert(message: "please provide Member Name", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[1] == "" {
            Alert().showAlert(message: "please provide Loan Type", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[2] == "" {
            Alert().showAlert(message: "please provide Loan Id", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[3] == "" {
            Alert().showAlert(message: "please provide Deduction Amount", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[4] == "" {
            Alert().showAlert(message: "please provide Start Date", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[5] == "" {
            Alert().showAlert(message: "please provide End Date", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[6] == "" {
            Alert().showAlert(message: "please provide Total Amount", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[7] == "" {
            Alert().showAlert(message: "please provide Bank Name", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[8] == "" {
            Alert().showAlert(message: "please provide Contact Person", viewController: self)
            return false
        }
        else if objAddLoanDetails.arrDescription[9] == "" {
            Alert().showAlert(message: "please provide Contact Number", viewController: self)
            return false
        }
        else if !validatePhoneNumber(value:objAddLoanDetails.arrDescription[9]) {
            Alert().showAlert(message: "please provide 10 digit Contact Number", viewController: self)
            return false
        }
        return true
    }
}
extension Date {
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    func addYear(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .year, value: n, to: self)!
    }
    func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }
}
