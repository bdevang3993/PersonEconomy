//
//  DevidePersonViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 23/11/21.
//

import UIKit

class DevidePersonViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrDevidePersonList = [DevidePersonModel]()
    var isFromDate:Bool = false
    var totalPerson:Int = 0
    var selectedSection:Int = 0
    var arrCheckAmount = [CheckAmount]()
    var advanceId:Int = 0
    var mainPersonName:String = ""
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Share Persons"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(DevidePersonViewController(), action: #selector(DevidePersonViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension DevidePersonViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return objDevidePersonViewModel.arrDevidePersonList.count
        }
       
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
        cell.btnCall.isHidden = true
        if indexPath.section == 0 {
            cell.lblTitle.text = "Total Person"
            cell.txtDescription.text = "\(objDevidePersonViewModel.totalPerson)"
            cell.btnSelection.tag = -1
        } else {
            cell.lblTitle.text = objDevidePersonViewModel.arrDevidePersonList[indexPath.row].strnickName
            if objDevidePersonViewModel.arrDevidePersonList[indexPath.row].strName.isEmpty {
                cell.txtDescription.text = kSelectOption
            } else {
                cell.txtDescription.text = objDevidePersonViewModel.arrDevidePersonList[indexPath.row].strName
            }
            cell.btnSelection.tag = indexPath.row
        }
        cell.selectedIndex = {[weak self] index in
            if index == -1 {
                self?.setUpTotalPerson(index: index)
            } else {
                self?.setUpPersonName(index: index)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension DevidePersonViewController {
    func configureData() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtn.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            viewBtn.frame.size.height = (60.0 * (screenWidth/320.0))
        }
        objDevidePersonViewModel.setHeaderView(headerView: self.viewHeader)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.objDevidePersonViewModel.mainPersonName = objExpenseAllData["sponserName"] as! String
        userExpanseId = objExpenseAllData["userExpenseId"] as! String
        btnSave.setUpButton()
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.delegate = self
        AllMemberList.shared.getMemberList { (record) in
            
        }
    }
    func getAdvanceId() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserAdvanceQuery.getRecordsCount { (record) in
            self.objDevidePersonViewModel.advanceId = record + 1
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func setUpTotalPerson(index:Int) {
        PickerView.objShared.setUPickerWithValue(arrData: ["2","3","4","5","6","7","8","9","10"], viewController: self) { (selectedValue) in
            self.objDevidePersonViewModel.totalPerson = Int(selectedValue)!
            self.objDevidePersonViewModel.arrDevidePersonList.removeAll()
            self.devidedPrice = Double(Double(self.totalAmount)/Double(self.objDevidePersonViewModel.totalPerson))
            for  i in 0...self.objDevidePersonViewModel.totalPerson - 2 {
                let data = DevidePersonModel(strnickName: "Person \(i+1)", strName: "", strSharedPrice: "\(self.devidedPrice.rounded(toPlaces: 2))", userId: "", status: "Borrow", date: self.selectedDate, paiedDate: "", sponserMebmberid: self.userExpanseId)
                self.objDevidePersonViewModel.arrDevidePersonList.append(data)
            }
            DispatchQueue.main.async {
                self.tblDisplayData.reloadData()
            }
        }
    }
    func setUpPersonName(index:Int) {
        PickerView.objShared.setUPickerWithValue(arrData: AllMemberList.shared.getNameArray(), viewController: self) { (selectedValue) in
            if selectedValue == self.objDevidePersonViewModel.mainPersonName {
                DispatchQueue.main.async {
                    Alert().showAlert(message: "This is sponser name please select other one", viewController: self)
                }
                return
            }
            var data:DevidePersonModel = self.objDevidePersonViewModel.arrDevidePersonList[index]
            let arrpersonName = self.objDevidePersonViewModel.arrDevidePersonList.filter{$0.strName == selectedValue}
            if arrpersonName.count > 0 {
                DispatchQueue.main.async {
                    Alert().showAlert(message: "This name already selected please select other one", viewController: self)
                }
                return
            }
            for i in 0...arrMemberList.count - 1 {
                let newData = arrMemberList[i]
                if selectedValue == newData["name"] as! String {
                    data.userId = newData["userid"] as! String
                }
            }
            data.strName = selectedValue
            self.objDevidePersonViewModel.arrDevidePersonList[index] = data
            DispatchQueue.main.async {
                self.tblDisplayData.reloadData()
            }
        }
    }
    func  saveInDatabase()  {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        for value in objDevidePersonViewModel.arrDevidePersonList {
            let saved = objUserAdvanceQuery.saveuserAdvanceDetail(advanceId: "\(objDevidePersonViewModel.advanceId)", date: value.date, item: objExpenseAllData["itemName"] as! String, name: value.strName, paidDate: "", price: "\(self.devidedPrice.rounded(toPlaces: 2))", status: "Borrow", transactionId: "", userExpenseId: objExpenseAllData["userExpenseId"] as! String)
            objDevidePersonViewModel.advanceId = objDevidePersonViewModel.advanceId + 1
        }
        var strAllMember:String = ""
        var allMember = objDevidePersonViewModel.arrDevidePersonList.compactMap{$0.strName}
        for i in 0...allMember.count - 1 {
            if i == 0 {
                strAllMember = allMember[0]
            } else {
                strAllMember = strAllMember + "," + allMember[i]
            }
        }
        let savedata =  objUserExpanseQuery.updateMemberWithSharedMember(userExpenseId: objExpenseAllData["userExpenseId"] as! String, shareMemberName: strAllMember)
        MBProgressHub.dismissLoadingSpinner(self.view)
        updateData!(strAllMember)
        self.dismiss(animated: true, completion: nil)
    }
}
