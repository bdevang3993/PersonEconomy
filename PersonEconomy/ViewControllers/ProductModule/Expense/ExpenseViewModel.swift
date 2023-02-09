//
//  ExpenseViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 09/01/21.
//

import UIKit
import SBPickerSelector
import FSCalendar
import IQKeyboardManagerSwift
import CoreData
import Floaty

class ExpenseViewModel: NSObject {
    var arrDescriptionTitle = ["Product Name","Price","Member Name","cheque number","Shared Member"]
    var arrDescription = ["","","","",""]
    var arrMemberName = [String]()
    var strConvertedDate:String = ""
    var headerViewXib:CommanView?
    var totalRecord:Int = 0
    var imageData = Data()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Expense View"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        //headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        //headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(ExpenseViewController(), action: #selector(ExpenseViewController.backClicked), for: .touchUpInside)
       // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension ExpenseViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 130
            } else {
                return 100
            }
        }else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 100
            } else {
                return 70
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return objExpenseViewModel.arrDescriptionTitle.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblExpense.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
            cell.lblTitle.text = objExpenseViewModel.arrDescriptionTitle[indexPath.row]
            cell.txtDescription.tag = indexPath.row
            cell.btnCall.isHidden = true
            cell.txtDescription.tag = indexPath.row
            cell.txtDescription.text = objExpenseViewModel.arrDescription[indexPath.row]
            if isFromAddExpense {
                if indexPath.row == 0 {
                    cell.txtDescription.isEnabled = true
                }
            }else {
                if indexPath.row == 0 {
                    cell.txtDescription.isEnabled = false
                }
            }
            if indexPath.row == 1 {
                cell.txtDescription.keyboardType = .decimalPad
            }
            if indexPath.row == 2 || indexPath.row == 4  {
                if !isFromAddExpense || indexPath.row == 4 {
                    cell.btnSelection.isEnabled = false
                    cell.imgDown.isHidden = true
                    cell.txtDescription.isEnabled = false
                } else {
                    cell.btnSelection.isEnabled = true
                    cell.imgDown.isHidden = false
                }
                if cell.txtDescription.text!.count <= 0  && indexPath.row == 2 {
                    cell.txtDescription.text = kSelectOption
                }
            }
            else {
                cell.txtDescription.delegate = self
                cell.btnSelection.isEnabled = false
                cell.imgDown.isHidden = true
            }
            cell.selectedIndex = { [weak self] index in
                self?.selectName()
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tblExpense.dequeueReusableCell(withIdentifier: "AddRecipesTableViewCell") as! AddRecipesTableViewCell
            if isFromAddExpense {
                cell.lblRecipsTitle.text = "Add bill recipes"
            }
            else {
                if isReciptAttached {
                    cell.lblRecipsTitle.text = "Show bill recipes"
                } else {
                    cell.lblRecipsTitle.text = "Add bill recipes"
                }
                
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if isFromAddExpense || !isReciptAttached {
                let alertController = UIAlertController(title: kAppName, message: kSelectOption, preferredStyle: .alert)
                // Create the actions
                let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    MBProgressHub.showLoadingSpinner(sender: self.view)
                    self.takeImageFromCamera()
                }
                let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    MBProgressHub.showLoadingSpinner(sender: self.view)
                    self.takeImageFromGallery()
                }
                // Add the actions
                alertController.addAction(cameraAction)
                alertController.addAction(galleryAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            } else {
                let objShowImage:ImageDisplayViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "ImageDisplayViewController") as! ImageDisplayViewController
                objShowImage.modalPresentationStyle = .overFullScreen
                objShowImage.imageData = objExpenseViewModel.imageData
                self.present(objShowImage, animated: true, completion: nil)
            }
        }
    }
}
extension ExpenseViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                let value = textField.text?.dropLast()
                objExpenseViewModel.arrDescription[textField.tag] = String(value!)
                return true
            }
        }
        if textField.tag == 0 {
            objExpenseViewModel.arrDescription[0] =  textField.text! + string
        } else if textField.tag == 1 {
            objExpenseViewModel.arrDescription[1] =  textField.text! + string
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tblExpense.reloadData()
        return true
    }
}
extension ExpenseViewController {
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            if success.0 == true {
                self!.objExpenseViewModel.imageData = success.1
            } else {
                Alert().showAlert(message: "your Image is not saved please try again", viewController: self!)
            }
        }
    }
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            DispatchQueue.main.async {
                if success.0 == true {
                    self!.objExpenseViewModel.imageData = success.1
                }else {
                    Alert().showAlert(message: "your Image is not saved please try again", viewController: self!)
                }
            }
        }
    }
    func selectName() {
        IQKeyboardManager.shared.resignFirstResponder()
        self.setUpPicker(arrPickerData: objExpenseViewModel.arrMemberName, viewController: self)
    }
    //MARK:- Picker View
    func setUpPicker(arrPickerData:[String],viewController:UIViewController)  {
        if arrPickerData.count > 0 {
            SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: arrPickerData).cancel {
                print("cancel, will be autodismissed")
                }.set { values in
                    if let values = values as? [String] {
                        self.objExpenseViewModel.arrDescription[2] = values[0]
                        self.tblExpense.reloadData()
                    }

            }.present(into: viewController)
        } else {
            self.showMember()
        }
    }
    
    func showMember() {
        let objFamilyMember:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
        objFamilyMember.taUpdateMember = { [weak self] value in
            AllMemberList.shared.getMemberList { (result) in
                self!.setMemberName()
            }
            
        }
        objFamilyMember.modalPresentationStyle = .overFullScreen
        self.present(objFamilyMember, animated: true, completion: nil)
    }
    
    func setMemberName()  {
        objExpenseViewModel.arrMemberName.removeAll()
        objExpenseViewModel.arrMemberName = AllMemberList.shared.getNameArray()
        if  objExpenseViewModel.arrMemberName.count <= 0 {
            DispatchQueue.main.async {
                setAlertWithCustomAction(viewController: self, message: "please add member from home screen with relation customer", ok: { (isValied) in
                    self.showMember()
                }, isCancel: false) { (isValied) in
                }
            }
        }
        MBProgressHub.dismissLoadingSpinner(self.view)
    }
    
    func setvalueInTextField() {
        if let expenseid = allData["userExpenseId"] {
            objExpenseViewModel.totalRecord = Int(expenseid as! String)!
        }
        if let itemName = allData["itemName"] {
            objExpenseViewModel.arrDescription[0] = itemName as! String
        }
        if let price = allData["price"] {
            objExpenseViewModel.arrDescription[1] = price as! String
        }
        if let sponserName = allData["sponserName"] {
            objExpenseViewModel.arrDescription[2] = sponserName as! String
        }
        if let sharedMember = allData["shareMemberName"] {
            objExpenseViewModel.arrDescription[4] = sharedMember as! String
        }
        if let recipts = allData["billRecips"] {
            self.objExpenseViewModel.imageData = recipts as! Data
            let bcf = ByteCountFormatter()
                  bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                  bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(self.objExpenseViewModel.imageData.count))
            if string == "Zero KB" {
                isReciptAttached = false
            }
            else {
                isReciptAttached = true
            }
        }
       
    }
}
//MARK:- Database setup
extension ExpenseViewController {
    func getTotalRecord() {
        objUserExpenseQuery.getRecordsCount { (record) in
            self.objExpenseViewModel.totalRecord = record + 1
        }
    }
    func saveDataInDataBase() {
        let saveData = objUserExpenseQuery.saveinDataBase(userExpenseId: "\(objExpenseViewModel.totalRecord)", itemName: objExpenseViewModel.arrDescription[0], price: objExpenseViewModel.arrDescription[1], sponserName: objExpenseViewModel.arrDescription[2], date:lblSelectedDate.text!, billRecips: self.objExpenseViewModel.imageData, chequeNumber: objExpenseViewModel.arrDescription[3], shareMemberName: "")
        if saveData {
            setAlertWithCustomAction(viewController: self, message: "data added", ok: { (success) in
                DispatchQueue.main.async {
                    self.taupdateDataBase!(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failure) in
                
            }
        }
    }
    
    func updateDataInDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserExpenseQuery.updateMember(userExpenseId: "\(objExpenseViewModel.totalRecord)", itemName: objExpenseViewModel.arrDescription[0], price: objExpenseViewModel.arrDescription[1], sponserName: objExpenseViewModel.arrDescription[2], date: lblSelectedDate.text!, billRecips: self.objExpenseViewModel.imageData, chequeNumber: objExpenseViewModel.arrDescription[3], shareMemberName: objExpenseViewModel.arrDescription[4]) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "data updated", ok: { (success) in
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.taupdateDataBase!(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failure) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    func deleteRecordFromDB() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserExpenseQuery.deleteUserExpense(userExpenseId: "\(objExpenseViewModel.totalRecord)") { (success) in
            setAlertWithCustomAction(viewController: self, message: "data deleted", ok: { (success) in
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.taupdateDataBase!(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failure) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
        
    }
    func shareWithMember() {
        let strMemberName = allData["shareMemberName"] as! String
        if  strMemberName != "" {
            Alert().showAlert(message: "Already save sharing person", viewController: self)
            return
        }
        let objDevidePerson:DevidePersonViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "DevidePersonViewController") as! DevidePersonViewController
        objDevidePerson.objExpenseAllData = allData
        objDevidePerson.totalAmount = Int(allData["price"] as! String)!
        objDevidePerson.selectedDate = dateFormatter.string(from: currentPage!)
        objDevidePerson.modalPresentationStyle = .overFullScreen
        objDevidePerson.updateData = {[weak self] value in
            self!.objExpenseViewModel.arrDescription[4] = value
            DispatchQueue.main.async {
                self?.tblExpense.reloadData()
            }
        }
        self.present(objDevidePerson, animated: true, completion: nil)
    }
}
extension ExpenseViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)

        floaty.addItem("Save user member to share",icon: UIImage(named: "user")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to share?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [self]
                    UIAlertAction in
                        self.shareWithMember()
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
extension ExpenseViewController : FSCalendarDataSource, FSCalendarDelegate {
      func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let value = checkForNextDate(selectedDate: date)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            return
        }
        if isFromAddExpense {
            _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
            objExpenseViewModel.strConvertedDate = convertdateFromDate(date: date)
            lblSelectedDate.text = converFunction( date: date)
          self.currentPage = date
          historySelectedDate = date
          self.viewDate.setCurrentPage(self.currentPage!, animated: true)
          self.viewDate.select(self.currentPage)
        }
      }
      func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      }
}
