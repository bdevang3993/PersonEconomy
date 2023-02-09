//
//  ReminderViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import SBPickerSelector
import Floaty

class ReminderViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrTitle = ["Reminder Name","Date","Time","Event Type","Set Type","Amount"]
    var arrDescription = ["","","","","",""]
    var arrEventType = ["Meeting","BirthDay","Pay"]
    var arrSetType = ["Yearly","Monthly","Weeakley","Daily","One Time"]
    var userDetailID:Int = -1
    func setHeaderView(headerView:UIView,isFromEdit:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromEdit {
            headerViewXib!.lblTitle.text = "Edit Reminder"
        }else {
            headerViewXib!.lblTitle.text = "Add Reminder"
        }
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(ReminderViewController(), action: #selector(ReminderViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension ReminderViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objReminderViewModel.arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplay.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.lblTitle.text = objReminderViewModel.arrTitle[indexPath.row]
        cell.txtDescription.text = objReminderViewModel.arrDescription[indexPath.row]
        cell.txtDescription.delegate = self
        cell.txtDescription.tag = indexPath.row
        cell.btnCall.isHidden = true
        cell.btnSelection.tag = indexPath.row
       
        if indexPath.row == 0 || indexPath.row == 5 {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
        } else {
            if objReminderViewModel.arrDescription[indexPath.row].isEmpty {
                cell.txtDescription.text = kSelectOption
            }
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
        }
        if isFromEdit && indexPath.row == 0 {
            cell.txtDescription.isEnabled = false
        }
        if indexPath.row == 5 {
            cell.txtDescription.keyboardType = .numberPad
        } else {
            cell.txtDescription.keyboardType = .default
        }
        cell.selectedIndex = {[weak self] index in
            if index == 1 {
                self?.setupPickerDate()
            } else if index == 2 {
                self?.setupPickerTime()
            } else if index == 3 {
                self?.setUpDataDisplay(arrData: self!.objReminderViewModel.arrEventType, index: index)
            } else {
                self?.setUpDataDisplay(arrData: self!.objReminderViewModel.arrSetType, index: index)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension ReminderViewController {
    func fetchid() {
         self.objUserReminderQuery.getRecordsCount(record: { (result) in
            self.objReminderViewModel.userDetailID = result + 1
        })
        //self.objUserReminderQuery.getRecordsCount() + 1
    }
    func setUpData() {
        if let name = dicData["reminderName"] {
            objReminderViewModel.arrDescription[0] = name as! String
        }
        if let date = dicData["date"] {
            objReminderViewModel.arrDescription[1] = date as! String
        }
        if let time = dicData["time"] {
            objReminderViewModel.arrDescription[2] = time as! String
        }
        if let eventType = dicData["eventType"] {
            objReminderViewModel.arrDescription[3] = eventType as! String
        }
        if let setType = dicData["setType"] {
            objReminderViewModel.arrDescription[4] = setType as! String
        }
        if let amount = dicData["amount"] {
            objReminderViewModel.arrDescription[5] = amount as! String
        }
        if let userReminderId = dicData["userReminderId"] {
            self.objReminderViewModel.userDetailID = userReminderId as! Int
        }
        
        DispatchQueue.main.async {
            self.tblDisplay.reloadData()
        }
    }
    func validateData() -> Bool {
        if objReminderViewModel.arrDescription[0].isEmpty {
            Alert().showAlert(message:"please provide reminder name", viewController: self)
            return false
        }
        if objReminderViewModel.arrDescription[1].isEmpty {
            Alert().showAlert(message: "please select date", viewController: self)
            return false
        }
        if objReminderViewModel.arrDescription[2].isEmpty {
            Alert().showAlert(message: "please select time", viewController: self)
            return false
        }
        if objReminderViewModel.arrDescription[3].isEmpty {
            Alert().showAlert(message: "please select event type", viewController: self)
            return false
        }
        if objReminderViewModel.arrDescription[4].isEmpty {
            Alert().showAlert(message: "please select set type", viewController: self)
            return false
        }
        return true
    }
    func saveinDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
       let objSaveData = self.objUserReminderQuery.saveinDataBase(userReminderId: self.objReminderViewModel.userDetailID, reminderName: objReminderViewModel.arrDescription[0], date: objReminderViewModel.arrDescription[1], time: objReminderViewModel.arrDescription[2], eventType: objReminderViewModel.arrDescription[3], setType: objReminderViewModel.arrDescription[4], amount: objReminderViewModel.arrDescription[5])
        self.scheduleNotification(notificationType: objReminderViewModel.arrDescription[0], selectedDate: objReminderViewModel.arrDescription[1], time: objReminderViewModel.arrDescription[2])
        
        if objSaveData {
            MBProgressHub.dismissLoadingSpinner(self.view)
            setAlertWithCustomAction(viewController: self, message:"data saved sucessfully", ok: { (isSuccess) in
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isfalse) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    func updateInData() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        self.objUserReminderQuery.updateMember(userReminderId: self.objReminderViewModel.userDetailID, reminderName: objReminderViewModel.arrDescription[0], date: objReminderViewModel.arrDescription[1], time: objReminderViewModel.arrDescription[2], eventType: objReminderViewModel.arrDescription[3], setType: objReminderViewModel.arrDescription[4], amount: objReminderViewModel.arrDescription[5]) { (isSUccess) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            setAlertWithCustomAction(viewController: self, message:"data updated sucessfully", ok: { (isSuccess) in
                self.scheduleNotification(notificationType: self.objReminderViewModel.arrDescription[0], selectedDate: self.objReminderViewModel.arrDescription[1], time: self.objReminderViewModel.arrDescription[2])
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isfalse) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    func scheduleNotification(notificationType:String,selectedDate:String,time:String) {
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Reminder Notification"
        content.title = "Reminder"
        content.body = "This is reminder for " + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        let date = Date()
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: Date())
        let arrdevidedString:[String] = myString.components(separatedBy: "-")
        let calendar = Calendar.current
        let hour = calendar.component(. hour, from: date)
        let minutes = calendar.component(. minute, from: date)
        var dateComponents1 = DateComponents()
        dateComponents1.year = Int(arrdevidedString[0])
        dateComponents1.month = Int(arrdevidedString[1])
        dateComponents1.day = Int(arrdevidedString[2])
        dateComponents1.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
        dateComponents1.hour = hour
        dateComponents1.minute = minutes
        let userCalendar1 = Calendar.current // user calendar
        let someDateTime1 = userCalendar1.date(from: dateComponents1)
        let arrSelectedDate:[String] = selectedDate.components(separatedBy: "/")
        var dateComponents = DateComponents()
        dateComponents.year = Int(arrSelectedDate[2])//2021
        dateComponents.month = Int(arrSelectedDate[1])//12
        dateComponents.day = Int(arrSelectedDate[0])
        dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
        let arrSelectedTime:[String] = time.components(separatedBy: ":")
        let newSelectedTime:[String] = arrSelectedTime[1].components(separatedBy: " ")
        var selectedhours:Int = 1
        if newSelectedTime[1] == "PM" {
            selectedhours = 12 +  Int(arrSelectedTime[0])!
        } else {
            selectedhours = Int(arrSelectedTime[0])!
        }
        dateComponents.hour = selectedhours
        dateComponents.minute = Int(newSelectedTime[0])
        
        
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        var timeInterval = someDateTime!.timeIntervalSince(someDateTime1!)
        if timeInterval < 0 {
            timeInterval = (someDateTime1?.timeIntervalSince(someDateTime!))!
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifier = "Local Notification"
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
    
    func deleteInDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        self.objUserReminderQuery.deleteuserData(userReminderId: self.objReminderViewModel.userDetailID) { (isSuccess) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            setAlertWithCustomAction(viewController: self, message:"data deleted sucessfully", ok: { (isSuccess) in
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isfalse) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    
    func setupPickerDate() {
        IQKeyboardManager.shared.resignFirstResponder()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear).cancel {
        }.set { values in
            if let values = values as? [Date] {
                self.objReminderViewModel.arrDescription[1] = self.dateFormatter.string(from: values[0])
                self.tblDisplay?.reloadData()
            }
        }.present(into:self)
    }
    func setupPickerTime() {
        IQKeyboardManager.shared.resignFirstResponder()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateHour).cancel {
        }.set { values in
            if let values = values as? [Date] {
                self.objReminderViewModel.arrDescription[2] = converttimeFromDate(date: values[0])
                self.tblDisplay?.reloadData()
            }
        }.present(into: self)
    }
    func setUpDataDisplay(arrData:[String],index:Int) {
        IQKeyboardManager.shared.resignFirstResponder()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: arrData).cancel {
            }.set { values in
                if let values = values as? [String] {
                    self.objReminderViewModel.arrDescription[index] = values[0]
                    self.tblDisplay.reloadData()
                }

        }.present(into: self)
    }
}
extension ReminderViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                let value = textField.text?.dropLast()
                objReminderViewModel.arrDescription[textField.tag] = String(value!)
                return true
            }
        }
        objReminderViewModel.arrDescription[textField.tag] = textField.text! + string
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblDisplay.reloadData()
        return true
    }
}

