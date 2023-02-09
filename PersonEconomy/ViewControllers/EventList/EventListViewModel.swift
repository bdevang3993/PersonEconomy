//
//  EventListViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/08/21.
//

import Foundation
import Floaty
import FSCalendar
class EventListViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Event List"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(EventListViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension EventListViewController {
    func configData() {
        self.lblNoDataFound.textColor = hexStringToUIColor(hex: strTheamColor)
        eventListViewModel.setHeaderView(headerView: self.viewForHeader)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        self.lblNoDataFound.isHidden = true
        self.fetchAllEvents()
        self.layoutFAB()
    }
    func fetchAllEvents() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        GetAllEventList.shared.fetchAllEvent { (arrEventList) in
            self.arrCombineData.removeAll()
            self.arrCombineData = arrEventList
            DispatchQueue.main.async {
                self.getReminderData()
                self.checkForupdateEvent()
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.tblDisplayData.reloadData()
            }
        }
    }
    func checkForupdateEvent() {
        for eventData in self.arrCombineData {
            let type:String = eventData["eventType"] as! String
            if type == "LIC" || type == "Loan" ||  type == "Mediclame" {
            } else {
                let newDate:String = eventData["date"] as! String
                var convertSavedDate:Date = dateFormatter.date(from: newDate)!
                let date = Date()
                
                let newDate1 = dateFormatter.string(from: date)
                let curentDate:Date = dateFormatter.date(from: newDate1)!
                let diffInDays:Int = Calendar.current.dateComponents([.day], from:curentDate, to:convertSavedDate).day!
              
                
                let calendar = Calendar.current
                var dateComponents = DateComponents()
                if diffInDays < 0 {
                    let eventType:String = eventData["setType"] as! String
                    if eventType == "Yearly" {
                        dateComponents.year = 1
                        let newDate = calendar.date(byAdding: dateComponents, to: convertSavedDate)
                        convertSavedDate = newDate!
                    } else if eventType == "Monthly" {
                        dateComponents.month = 1
                        let newDate = calendar.date(byAdding: dateComponents, to: convertSavedDate)
                        convertSavedDate = newDate!
                    } else if eventType == "Weeakley" {
                        dateComponents.day = 7
                        let newDate = calendar.date(byAdding: dateComponents, to: convertSavedDate)
                        convertSavedDate = newDate!
                    } else if eventType == "Daily" {
                        dateComponents.day = 1
                        let newDate = calendar.date(byAdding: dateComponents, to: convertSavedDate)
                        convertSavedDate = newDate!
                    }
                    var newSearchData:[String:Any] = eventData
                    newSearchData["date"] = dateFormatter.string(from: convertSavedDate)
                    self.updateDataInReminder(eventData: newSearchData)
                }
            }
        }
    }
    
    func updateDataInReminder(eventData:[String:Any]) {
        self.scheduleNotification(notificationType: eventData["reminderName"] as! String, selectedDate: eventData["date"] as! String, time: eventData["time"] as! String)
        objUserReminderQuery.updateMember(userReminderId: eventData["userReminderId"] as! Int, reminderName: eventData["reminderName"] as! String, date: eventData["date"] as! String, time: eventData["time"] as! String, eventType: eventData["eventType"] as! String, setType: eventData["setType"] as! String, amount: eventData["amount"] as! String) { (isSuccess) in
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
    
    func getReminderData()  {
          objUserReminderQuery.fetchData(record: { (result) in
            self.arrReminderData = result
          }) { (isFailed) in
          }
    }
    
    func moveToLICDetail(data:[String:Any]) {
        let objLICDescription:LICDescriptionViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LICDescriptionViewController") as! LICDescriptionViewController
        objLICDescription.dicLICDescription = data
        objLICDescription.modalPresentationStyle = .overFullScreen
        objLICDescription.cdUpdateData = {[weak self] in
            self?.fetchAllEvents()
        }
        self.present(objLICDescription, animated: true, completion: nil)
    }
    
    func moveToLoanDetail(data:[String:Any]) {
        
        let objLoanDescription:LoanDescriptionViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "LoanDescriptionViewController") as! LoanDescriptionViewController
        objLoanDescription.arrLoanDetails = data
        objLoanDescription.clUpdateData = {[weak self] in
            self?.fetchAllEvents()
        }
        objLoanDescription.modalPresentationStyle = .overFullScreen
        self.present(objLoanDescription, animated: true, completion: nil)
    }
    
    func moveToMediclamDetail(data:[String:Any]) {
        let objMediclamViewController:AddMedicalmViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "AddMedicalmViewController") as! AddMedicalmViewController
        objMediclamViewController.modalPresentationStyle = .overFullScreen
        objMediclamViewController.updateData = { [weak self] in
            self?.fetchAllEvents()
        }
        objMediclamViewController.isFromEdit = true
        objMediclamViewController.dicMediclamData = data
        self.present(objMediclamViewController, animated: true, completion: nil)
    }
    
    func moveToReminder(data:[String:Any]) {
        var newSavedData = [String:Any]()
        for i in 0...arrReminderData.count - 1 {
            let newData:[String:Any] = arrReminderData[i]
            let name = newData["reminderName"] as! String
            if  name == data["eventType"] as! String {
                newSavedData = newData
                break
            }
        }
        let objReminderViewController:ReminderViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "ReminderViewController") as! ReminderViewController
        objReminderViewController.modalPresentationStyle = .overFullScreen
        objReminderViewController.isFromEdit = true
        objReminderViewController.dicData = newSavedData
        objReminderViewController.updateData = {[weak self] in
            self?.fetchAllEvents()
        }
        self.present(objReminderViewController, animated: true, completion: nil)
    }

    
    func setUpSelectedLoanColor(date:String,data:[String:Any]) -> Bool {
        if arrSelectedData.count > 0 {
            for selectedData in arrSelectedData {
                if let loanId = selectedData["loanId"] {
                    let loanIdData:String = (loanId as? String)!
                    if let newLoanId = data["loanId"] {
                        let newLoanIdData = (newLoanId as? String)!
                        if let selectedDate = selectedData["date"] {
                            let selectedDate1 = selectedDate as? String
                            if newLoanIdData == loanIdData {
                                if selectedDate1 == date {
                                    return true
                                }
                            }
                        }
                        
                    }
                }
            }
        }
      return false
    }
    
    func setUpSelectedLICColor(date:String,data:[String:Any]) -> Bool {
        if arrSelectedData.count > 0 {
            for selectedData in arrSelectedData {
                if let policyNumber = selectedData["policyNumber"] {
                    let policyNumberData:String = (policyNumber as? String)!
                    if let newpolicyNumber = data["policyNumber"] {
                        let newLoanIdData = (newpolicyNumber as? String)!
                        if let selectedDate = selectedData["date"] {
                            let selectedDate1 = selectedDate as? String
                            if newLoanIdData == policyNumberData {
                                if selectedDate1 == date {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    func setUpReminder() {
        let objReminderViewController:ReminderViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "ReminderViewController") as! ReminderViewController
        objReminderViewController.modalPresentationStyle = .overFullScreen
        objReminderViewController.isFromEdit = false
        objReminderViewController.updateData = {
            self.fetchAllEvents()
        }
        self.present(objReminderViewController, animated: true, completion: nil)
    }
}
extension EventListViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return arrCombineData.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section == 0 {
                return 90
            } else {
                return 80
            }
        }
        else {
            if indexPath.section == 0 {
                return 60
            } else {
                return 50
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
            let data = arrCombineData[indexPath.row]
            if let type = data["eventType"] {
                cell.lblEventName.text = (type as! String)
            }
            if let date = data["date"] {
                cell.lblDate.text = date as? String
            }
            if let days = data["daysRemaining"] {
                cell.lblDays.text =  (days as? String)! + " Days"
            }
            cell.contentView.backgroundColor = .white
            let selectedLoan = self.setUpSelectedLoanColor(date: cell.lblDate.text!, data: data)
            let selectedLIC = self.setUpSelectedLICColor(date: cell.lblDate.text!, data: data)
            if selectedLIC || selectedLoan {
                cell.contentView.backgroundColor = .orange
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let dicData = arrCombineData[indexPath.row]
            let type:String = dicData["eventType"] as! String
            if type == "LIC" {
                self.moveToLICDetail(data: dicData)
            } else if type == "Loan" {
                self.moveToLoanDetail(data: dicData)
            } else if type == "Mediclame" {
                self.moveToMediclamDetail(data: dicData)
            } else {
                self.moveToReminder(data: dicData)
            }
        }
    }
}
extension EventListViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add Reminder", icon: UIImage(named: "reminder")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to add Reminder?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.setUpReminder()
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
