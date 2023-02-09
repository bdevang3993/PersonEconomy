//
//  AddBorrowViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 24/02/21.
//

import UIKit
import FSCalendar
import IQKeyboardManagerSwift
typealias removeallValueFromTextFieldClosure = () -> Void
class AddBorrowViewModel: NSObject {
    var reloadTbl:reloadTableViewClosure?
    var arrTitle = ["Name","Item","Price","Cheque number or Transaction Id","Status","Paid Date"]
    var arrDescription = ["","","","",kSelectOption,kOptionalDateSelectrion]
    var headerViewXib:CommanView?
    var isFromEdit:Bool = false
    var emptyTextField:removeallValueFromTextFieldClosure?
    var totalRecord:Int = 0
    var arrCustomerName = [String]()
    var strConvertedDate:String = "" {
        didSet {
            emptyTextField!()
        }
    }
    
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        var strTitle:String = "Add Account Detail"
        if isFromEdit {
            strTitle = "Edit Account Detail"
        }
        headerViewXib!.lblTitle.text = strTitle //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(AddBorrowViewController(), action: #selector(AddBorrowViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension AddBorrowViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddBorrowViewModel.arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBorrow.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.btnSelection.tag = indexPath.row
        cell.lblTitle.text = objAddBorrowViewModel.arrTitle[indexPath.row]
        cell.txtDescription.tag = indexPath.row
        cell.txtDescription.text = objAddBorrowViewModel.arrDescription[indexPath.row]
        cell.btnCall.isHidden = true
        if indexPath.row == 2 {
            cell.txtDescription.keyboardType = .numberPad
        } else {
            cell.txtDescription.keyboardType = .alphabet
        }
        if indexPath.row == 4 || indexPath.row == 5 || (indexPath.row == 0 && !self.isfromEdit)  {
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
            if cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
        }
        else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
            cell.txtDescription.delegate = self
        }
        if indexPath.row == 0 && self.isfromEdit {
            cell.txtDescription.isEnabled = false
        }
        
        cell.selectedIndex = {[weak self] value in
            DispatchQueue.main.async {
                if value == 0  && !self!.isfromEdit {
                    self?.setupMemberPicker(index: value)
                }
                else if value == 4 {
                    self?.setUpStatusPicker(index: value)
                }
                else {
                    self?.setUpPaiedatePicker(index: value)
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension AddBorrowViewController {
    func  setupMemberPicker(index:Int) {
        IQKeyboardManager.shared.resignFirstResponder()
        if self.objAddBorrowViewModel.arrCustomerName.count > 0 {
            PickerView.objShared.setUPickerWithValue(arrData: self.objAddBorrowViewModel.arrCustomerName, viewController: self) { (memberName) in
                self.objAddBorrowViewModel.arrDescription[index] = memberName
                self.tblBorrow.reloadData()
            }
        }else {
            setAlertWithCustomAction(viewController: self, message: "please add mebmer as customer type", ok: { (isValied) in
                self.showMember()
            }, isCancel: false) { (isValied) in
            }
        }
    }
    func setUpStatusPicker(index:Int) {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: ["Borrow","Paied","Advance"], viewController: self) { (selectedValue) in
            self.objAddBorrowViewModel.arrDescription[index] = selectedValue
            self.tblBorrow.reloadData()
        }
    }
    func setUpPaiedatePicker(index:Int) {
        if self.objAddBorrowViewModel.arrDescription[4] == "Borrow" {
            Alert().showAlert(message: "If bill status paied then only we can add date", viewController: self)
        }else {
            PickerView.objShared.setUpDatePickerWithDate(viewController: self) {
                    (selectedValue) in
                let strSelectedvalue = self.dateFormatter.string(from: selectedValue)
                self.objAddBorrowViewModel.arrDescription[index] = strSelectedvalue
                self.tblBorrow.reloadData()
            }
        }
    }
    func setConfiguration(){
        
        if UIDevice.current.userInterfaceIdiom == .pad {
                  viewBtnSave.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewBtnSave.frame.size.height = (60.0 * (screenWidth/320.0))
              }
        btnDelete.isHidden = true
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        objAddBorrowViewModel.isFromEdit = isfromEdit
        objAddBorrowViewModel.setHeaderView(headerView: viewHeader)
        self.calenderView.scope = .week
        self.calenderView.dataSource = self
        self.calenderView.delegate = self
        var fontSize:CGFloat = 18.0
        var rowHeight:CGFloat = 40.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 28.0
            rowHeight = 60.0
        }
        //self.calenderView.appearance.headerTitleFont = UIFont.systemFont(ofSize: fontSize)
        self.calenderView.appearance.weekdayFont = UIFont.systemFont(ofSize: fontSize)
        self.calenderView.appearance.titleFont =  UIFont.systemFont(ofSize: fontSize - 4.0)
        self.calenderView.rowHeight = rowHeight
        self.calenderView.weekdayHeight = rowHeight
        
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        calenderView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
        
        if isfromEdit {
            btnDelete.isHidden = false
            self.setUpDataWhenEdit()
            self.calenderView.allowsSelection = false
            self.btnNext.isEnabled = false
            self.btnPrevious.isEnabled = false
        } else {
            self.getAllRecord()
        }
        objAddBorrowViewModel.emptyTextField = {[weak self]  in
            DispatchQueue.main.async {
                if !self!.isfromEdit {
                    self?.removeAllValueFromTextField()
                }
            }
        }
        tblBorrow.dataSource = self
        tblBorrow.delegate = self
        if currentPage == nil {
            currentPage = Date()
        }
        objAddBorrowViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction(date: currentPage!)
        lblDate.adjustsFontSizeToFitWidth = true
        lblDate.numberOfLines = 0
        lblDate.sizeToFit()
        //   self.view.addGestureRecognizer(self.scopeGesture)
        
        btnSave.setUpButton()
        self.getAllMemberName()
    }
    func getAllMemberName() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        AllMemberList.shared.getMemberList { (result) in
            arrMemberList = result
            if arrMemberList.count <= 0 {
                DispatchQueue.main.async {
                    setAlertWithCustomAction(viewController: self, message: kPleaseAddMember, ok: { (isValied) in
                        self.showMember()
                    }, isCancel: false) { (isValied) in
                    }
                }
                MBProgressHub.dismissLoadingSpinner(self.view)
            } else {
                self.setMemberName()
            }
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
        objAddBorrowViewModel.arrCustomerName.removeAll()
        objAddBorrowViewModel.arrCustomerName = AllMemberList.shared.getCustomerNameArray()
        if  objAddBorrowViewModel.arrCustomerName.count <= 0 {
            DispatchQueue.main.async {
                if !self.isfromEdit {
                    setAlertWithCustomAction(viewController: self, message: "please add member from home screen with relation customer", ok: { (isValied) in
                        self.showMember()
                    }, isCancel: false) { (isValied) in
                    }
                }

            }
        }
        DispatchQueue.main.async {
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    
    func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = moveUp ? 1 : -1
        let currentDate = self.currentPage
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? today())
        let value = checkForNextDate(selectedDate: self.currentPage!)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            self.currentPage = currentDate
            return
        }
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
        historySelectedDate = self.currentPage!
        objAddBorrowViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction( date: self.currentPage!)
    }
    func setUpDataWhenEdit() {
        if let advanceId = dicBorrowData["advanceId"] {
            objAddBorrowViewModel.totalRecord = Int(advanceId as! String)!
        }
        if let name = dicBorrowData["name"] {
            objAddBorrowViewModel.arrDescription[0] = name as! String
        }
        if let item = dicBorrowData["item"] {
            objAddBorrowViewModel.arrDescription[1] = item as! String
        }
        if let price = dicBorrowData["price"] {
            objAddBorrowViewModel.arrDescription[2] = price as! String
        }
        if let transactionId = dicBorrowData["transactionId"] {
            objAddBorrowViewModel.arrDescription[3] = transactionId as! String
        }
        if let status = dicBorrowData["status"] {
            objAddBorrowViewModel.arrDescription[4] = status as! String
        }
        if let paidDate = dicBorrowData["paidDate"] {
            if paidDate as! String == "" {
                objAddBorrowViewModel.arrDescription[5] = kOptionalDateSelectrion
            }else {
                objAddBorrowViewModel.arrDescription[5] = paidDate as! String
            }
        }
        self.tblBorrow.reloadData()
    }
    func removeAllValueFromTextField() {
        for i in 0...objAddBorrowViewModel.arrDescription.count - 1 {
            objAddBorrowViewModel.arrDescription[i] = ""
        }
        objAddBorrowViewModel.arrDescription[objAddBorrowViewModel.arrDescription.count - 2] = kSelectOption//
        objAddBorrowViewModel.arrDescription[objAddBorrowViewModel.arrDescription.count - 1] = kOptionalDateSelectrion
        self.tblBorrow.reloadData()
    }
    
      func validation() -> Bool {
          if objAddBorrowViewModel.arrDescription[0].isEmpty {
              Alert().showAlert(message: "please provid Name", viewController: self)
              return false
          }
          if objAddBorrowViewModel.arrDescription[1].isEmpty {
              Alert().showAlert(message: "please provid Item", viewController: self)
              return false
          }
          if objAddBorrowViewModel.arrDescription[2].isEmpty {
              Alert().showAlert(message: "please provid Price", viewController: self)
              return false
          }
          if objAddBorrowViewModel.arrDescription[4] == "please selecte one option" {
              Alert().showAlert(message: "please select status", viewController: self)
              return false
          }
          return true
      }
}
extension AddBorrowViewController {
    func getAllRecord()  {
        objUserAdvanceQuery.getRecordsCount { (record) in
            self.objAddBorrowViewModel.totalRecord = record + 1
        }
    }
    
    func saveInDatabase()  {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        let datasaved = objUserAdvanceQuery.saveuserAdvanceDetail(advanceId: "\(objAddBorrowViewModel.totalRecord)", date: dateFormatter.string(from: currentPage!), item: objAddBorrowViewModel.arrDescription[1], name: objAddBorrowViewModel.arrDescription[0], paidDate: "", price: objAddBorrowViewModel.arrDescription[2], status: objAddBorrowViewModel.arrDescription[4], transactionId: "", userExpenseId: "")
        if datasaved {
            MBProgressHub.dismissLoadingSpinner(self.view)
            setAlertWithCustomAction(viewController: self, message: "Data saved", ok: { (success) in
                DispatchQueue.main.async {
                    self.updatcallBack!()
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    func updateInDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserAdvanceQuery.updateuserAdvanceDetails(date: dateFormatter.string(from: currentPage!), item: objAddBorrowViewModel.arrDescription[1], name: objAddBorrowViewModel.arrDescription[0], paidDate: objAddBorrowViewModel.arrDescription[5], price: objAddBorrowViewModel.arrDescription[2], status: objAddBorrowViewModel.arrDescription[4], transactionId: objAddBorrowViewModel.arrDescription[3], advanceId: "\(objAddBorrowViewModel.totalRecord)", userExpenseId: "") { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Data saved", ok: { (success) in
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.updatcallBack!()
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    func deleteDataFromDB() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserAdvanceQuery.deleteuserAdvanceDetail(advanceId: "\(objAddBorrowViewModel.totalRecord)") { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Data Deleted", ok: { (success) in
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.updatcallBack!()
                    self.dismiss(animated: true, completion: nil)
                }
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }

        }
    }
}
extension AddBorrowViewController : FSCalendarDataSource, FSCalendarDelegate {
      func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let value = checkForNextDate(selectedDate: date)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            return
        }
        if isfromEdit {
            return
        }
         
        _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        objAddBorrowViewModel.strConvertedDate = convertdateFromDate(date: date)
          lblDate.text = converFunction( date: date)
        self.currentPage = date
        historySelectedDate = date
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
      }
      func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      }
}
extension AddBorrowViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objAddBorrowViewModel.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        objAddBorrowViewModel.arrDescription[textField.tag] = textField.text! + string
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblBorrow.reloadData()
        return true
    }
}
