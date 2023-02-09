//
//  HomeViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import Floaty
import FSCalendar
import CoreData

class HomeViewModel: NSObject {
    var strConvertedDate:String = ""
    var headerViewXib:CommanView?
    
    
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Home"//"Journal List"
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            headerViewXib!.lblTitle.font =  headerViewXib!.lblTitle.font.withSize(30.0)
//        }
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        //headerViewXib!.btnBack.setImage(UIImage(named: "drawer"), for: .normal)
        headerViewXib!.lblBack.isHidden = true
      //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(HomeViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
       // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension HomeViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add Expense", icon: UIImage(named: "expanse")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to add Expense?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.nextToExpense()
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
        
        floaty.addItem("Delete Expense", icon: UIImage(named: "expanse")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to delete Expense between two dates?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.deleteExpenseBetweenDates()
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
        floaty.addItem("Add Member",icon: UIImage(named: "user")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to add member?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.nextToFamilyMember()
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
        
        floaty.addItem("Show Member",icon: UIImage(named: "user")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to Display all member?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.goToMemberDisplay()
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
        floaty.addItem("Share",icon: UIImage(named: "share")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to share?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [self]
                    UIAlertAction in
                    if objExpenseAllData.count > 0 {
                        let image = self.screenshot()
                        self.shareImage(image: image)
                    } else {
                        Alert().showAlert(message: "Please first enter the expanse", viewController: self)
                    }
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
        floaty.addItem("Change Theam",icon: UIImage(named: "theam")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to Change theam color?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [self]
                    UIAlertAction in
                    self.moveToTheamPicker()
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
        
        
        
        //floaty.addItem(item: item)
        //floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
       
        self.view.addSubview(floaty)
    }
}
extension HomeViewController {
    
    func screenshot() -> UIImage{

        let datedisplay:UIView = UIView(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 40))
        let lblDate:UILabel = UILabel(frame: CGRect(x: 0, y: 5, width: screenWidth, height: 30))
        
        lblDate.text = self.lblDate.text
        lblDate.textAlignment = .center
        datedisplay.addSubview(lblDate)
        datedisplay.backgroundColor = .white
        let imageDate = datedisplay.screenshot
        let tableViewImage = self.tblDisplayData.screenshot
        let newImage = imageDate?.mergeImage(image2: tableViewImage!)
        return newImage!
    }
    
    
    func shareImage(image:UIImage) {
        //let image = UIImage(named: "Product")
        let imageShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
     }
    
    func nextToFamilyMember() {
        let objFamilyMember:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
        objFamilyMember.taUpdateMember = { [weak self] value in
            
        }
        objFamilyMember.modalPresentationStyle = .overFullScreen
        self.present(objFamilyMember, animated: true, completion: nil)
    }
    func deleteExpenseBetweenDates() {
        let objPayment:PaySomeAmountViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "PaySomeAmountViewController") as! PaySomeAmountViewController
        objPayment.modalPresentationStyle = .overFullScreen
        objPayment.isFromSelectDate = true
        objPayment.updateAllData = {[weak self] in
            self?.getAllDataFromDB()
        }
        self.present(objPayment, animated: true, completion: nil)
    }
    
    func nextToExpense() {
            let objExpense:ExpenseViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "ExpenseViewController") as! ExpenseViewController
        objExpense.currentPage = currentPage
        objExpense.taupdateDataBase = {[weak self] value in
            self?.getAllDataFromDB()
        }
            objExpense.modalPresentationStyle = .overFullScreen
            self.present(objExpense, animated: true, completion: nil)
        }
    
    func goToMemberDisplay() {
        let objMemberDisplay:FamilyDetailsDisplayViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsDisplayViewController") as! FamilyDetailsDisplayViewController
        
        objMemberDisplay.modalPresentationStyle = .overFullScreen
        self.present(objMemberDisplay, animated: true, completion: nil)
    }

    func moveToTheamPicker() {
        let objTheamPicker:TheamPickerViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "TheamPickerViewController") as! TheamPickerViewController
        objTheamPicker.modalPresentationStyle = .overFullScreen
        objTheamPicker.clUpdateColor = { [weak self] isChange in
            DispatchQueue.main.async {
                self!.viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
                self!.calenderView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
                self!.viewHeader.backgroundColor = hexStringToUIColor(hex: strTheamColor)
                self!.floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
                self!.tblDisplayData.reloadData()
            }
        }
        self.present(objTheamPicker, animated: true, completion: nil)
    }
    
//MARK:- Get all date
    func fetchAllDate() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objLoanEntry.fetchAllData { (result) in
            self.arrLoanDetails = result
            if self.arrLoanDetails.count > 0 {
                for arrLoanData in self.arrLoanDetails {
                    if let date = arrLoanData["date"] {
                        self.datesWithMultipleEvents.append(date as! String)
                    }
                }
            }
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.calenderView.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }

        objLICEntryPerMonthQuery.fetchAllData { (result) in
            self.arrDisplayData = result
            if self.arrDisplayData.count > 0 {
                for arrdisplayDate in self.arrDisplayData {
                    if let date = arrdisplayDate["date"] {
                        self.datesWithMultipleEvents.append(date as! String)
                    }
                }
            }
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.calenderView.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
        
    }
    
    func setUpAlert(date:String) {
        setAlertWithCustomAction(viewController: self, message: "Are you want to check the event?", ok: { (isSelected) in
            var arrAllSelectedData = [[String:Any]]()
            for allData in self.arrLoanDetails {
                let value = allData["date"]
                if value as! String == date {
                    arrAllSelectedData.append(allData)
                }
            }
            
            for allNewData in self.arrDisplayData {
                let value = allNewData["date"]
                if value as! String == date {
                    arrAllSelectedData.append(allNewData)
                }
            }
            
            DispatchQueue.main.async {
                let objEventDisplay = UIStoryboard(name:kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "EventListViewController") as! EventListViewController
                objEventDisplay.arrSelectedData = arrAllSelectedData
                self.revealViewController()?.pushFrontViewController(objEventDisplay, animated: true)
            }
        }, isCancel: true) { (isSelected) in
        }
    }
    
    func fetchAllEvents() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        GetAllEventList.shared.checkForDays = 10
        GetAllEventList.shared.fetchAllEvent { (arrEventList) in
            if arrEventList.count > 0 {
                for dicEvent in arrEventList {
                    let type:String = dicEvent["eventType"] as! String
                    let days:String = dicEvent["daysRemaining"] as! String
                    self.scheduleNotification(type: type , remainingDays: days)
                }
            }
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.appDelegate.isFirstTime = false
                let userDefault = UserDefaults.standard
                let date = Date()
                userDefault.set(date, forKey: kDate)
                userDefault.synchronize()
            }
        }
    }
    //MARK:- Schedule LocalNotification
    func scheduleNotification(type: String, remainingDays:String) {
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Event Update"
        content.sound = UNNotificationSound.default
        content.body = "Your Event type is \(type) and  number of days remains \(remainingDays) please check before expird"
        content.categoryIdentifier = categoryIdentifire
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let identifier = "Local Notification"
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

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return objExpenseAllData.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let objData = objExpenseAllData[indexPath.row]
            if let itemName = objData["itemName"] {
                cell.lblItemDetails.text = (itemName as! String)
            }
            if let itemPrice = objData["price"] {
                cell.lblItemPrice.text = (itemPrice as! String)
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            let  cell = tblDisplayData.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = "\(totoalAmount)"
            cell.lblTotalPrice.adjustsFontSizeToFitWidth = true
            cell.lblTotalPrice.numberOfLines = 0
            cell.lblTotalPrice.sizeToFit()
            cell.lblTotalAmount.adjustsFontSizeToFitWidth = true
            cell.lblTotalAmount.numberOfLines = 0
            cell.lblTotalAmount.sizeToFit()
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let objExpense:ExpenseViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "ExpenseViewController") as! ExpenseViewController
            objExpense.isFromAddExpense = false
            objExpense.strSelectedDate = lblDate.text!
            objExpense.allData = objExpenseAllData[indexPath.row]
            objExpense.currentPage = currentPage
            objExpense.taupdateDataBase = {[weak self] value in
                self?.getAllDataFromDB()
            }
            objExpense.isFromAddExpense = false
            objExpense.modalPresentationStyle = .overFullScreen
            self.present(objExpense, animated: true, completion: nil)
        }
    }
}
extension HomeViewController : FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = self.dateFormatter.string(from: date)
        
        if self.datesWithMultipleEvents.contains(key) {
            return 1
        } else {
            return 0
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let value = checkForNextDate(selectedDate: date)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            return
        }
        let key = self.dateFormatter.string(from: date)
        if self.datesWithMultipleEvents.contains(key) {
            self.setUpAlert(date: key)
        }
        _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        objHomeViewModel.strConvertedDate = convertdateFromDate(date: date)
        lblDate.text = converFunction( date: date)
        self.currentPage = date
        historySelectedDate = date
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
        self.getAllDataFromDB()
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
}
