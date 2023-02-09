//
//  CommonSearchViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 06/03/21.
//

import UIKit
import IQKeyboardManagerSwift

class CommonSearchViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrLoanDetail = [[String:Any]]()
    var arrMedicalDetail = [[String:Any]]()
    var arrLICDetail = [[String:Any]]()
    var arrExpenseDetail = [[String:Any]]()
    var arrMediclameDetail = [[String:Any]]()
    var arrSectionName = ["Loan","Mediclame","Medical","LIC","Expense"]
    var totalAmount:Double = 0
    var arrNameList = [String]()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Search"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(CommonSearchViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension CommonSearchViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return objCommonSearchViewModel.arrSectionName.count + 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < objCommonSearchViewModel.arrSectionName.count {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 70
            }
            else {
                return 50
            }
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var height:CGFloat = 50.0
        var fontsize:CGFloat = 20.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            height  = 70.0
            fontsize = 30.0
        }
        let view:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: height))
        let lbl:UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: height))
        lbl.font = UIFont.systemFont(ofSize: fontsize)
        lbl.backgroundColor = .lightGray
        lbl.textColor = .black
        lbl.text = "  " + self.objCommonSearchViewModel.arrSectionName[section]
        view.addSubview(lbl)
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if objCommonSearchViewModel.arrSectionName.count < indexPath.row {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 130
            } else {
                return 100
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 100
            } else {
                return 70
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return objCommonSearchViewModel.arrLoanDetail.count
        }
        else if section == 1 {
            return objCommonSearchViewModel.arrMediclameDetail.count
        }
        else if section == 2 {
            return objCommonSearchViewModel.arrMedicalDetail.count
        }
        else if section == 3 {
            return objCommonSearchViewModel.arrLICDetail.count
        }
        else if section == 4 {
            return objCommonSearchViewModel.arrExpenseDetail.count
        }
        if section == objCommonSearchViewModel.arrSectionName.count  {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != objCommonSearchViewModel.arrSectionName.count {
            cell.transform = CGAffineTransform(rotationAngle: 360)
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                cell.transform = CGAffineTransform(rotationAngle: 0.0)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == objCommonSearchViewModel.arrSectionName.count  {
            let cell = tblSearch.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = "\(objCommonSearchViewModel.totalAmount.rounded(toPlaces: 2))"
            return cell
        } else {
            let cell = tblSearch.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            if indexPath.section == 0 {
                let data =  objCommonSearchViewModel.arrLoanDetail[indexPath.row]
                if let date = data["startDate"] {
                    cell.lblDateofPay.text = (date as! String)
                }
                if let bankName = data["bankName"]{
                    cell.lblBankName.text = (bankName as! String)
                }
                if let amount = data["totalAmount"] {
                    cell.lblDeduction.text = (amount as! String)
                }
               
            } else if indexPath.section == 1 {
                let data =  objCommonSearchViewModel.arrMediclameDetail[indexPath.row]
                if let date = data["startDate"] {
                    cell.lblDateofPay.text = (date as! String)
                }
                if let bankName = data["type"]{
                    cell.lblBankName.text = (bankName as! String)
                }
                if let amount = data["price"] {
                    cell.lblDeduction.text = (amount as! String)
                }
            }
            
            else if indexPath.section == 2 {
                let data =  objCommonSearchViewModel.arrMedicalDetail[indexPath.row]
                if let date = data["admittedDate"] {
                    cell.lblDateofPay.text = (date as! String)
                }
                if let bankName = data["hospitalName"]{
                    cell.lblBankName.text = (bankName as! String)
                }
                if let amount = data["amount"] {
                    cell.lblDeduction.text = (amount as! String)
                }
            }
            else if indexPath.section == 3 {
                let data =  objCommonSearchViewModel.arrLICDetail[indexPath.row]
                if let date = data["date"] {
                    cell.lblDateofPay.text = (date as! String)
                }
                cell.lblBankName.text = "LIC"
                var totalMonths:Int = 0
                if let month = data["months"] {
                    totalMonths = Int(month as! String)!
                }
                if let amount = data["amount"] {
                    var totalAmount:Int = 0
                    let amount:Int = Int(amount as! String)!
                    totalAmount = totalMonths * amount
                    cell.lblDeduction.text = "\(totalAmount)"
                }
            }
            else  {
                let data =  objCommonSearchViewModel.arrExpenseDetail[indexPath.row]
                if let date = data["date"] {
                    let newDate = convertDateFromString(date: date as! String)
                    cell.lblDateofPay.text = convertdateFormatterFromDate(date: newDate)
                }
                if let bankName = data["itemName"]{
                    cell.lblBankName.text = (bankName as! String)
                }
                if let amount = data["price"] {
                    cell.lblDeduction.text = (amount as! String)
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension CommonSearchViewController {
    func configData() {
        txtName.textColor = hexStringToUIColor(hex: strTheamColor)
        lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
        lblNoData.isHidden = false
        tblSearch.isHidden = true
        objCommonSearchViewModel.setHeaderView(headerView: self.viewHeader)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        imgDown.tintColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        tblSearch.delegate = self
        tblSearch.dataSource = self
        txtName.layer.borderWidth = 1.0
        txtName.layer.borderColor = UIColor.white.cgColor
        self.getMemberName()
        tblSearch.tableFooterView = UIView()
    }
    func fetchSearchData() {
        lblNoData.isHidden = true
        self.tblSearch.isHidden = false
        objCommonSearchViewModel.arrLoanDetail.removeAll()
        objCommonSearchViewModel.arrMedicalDetail.removeAll()
        objCommonSearchViewModel.arrLICDetail.removeAll()
        objCommonSearchViewModel.arrExpenseDetail.removeAll()
        objCommonSearchViewModel.arrMediclameDetail.removeAll()
        objCommonSearchViewModel.totalAmount = 0
        self.tblSearch.reloadData()
       // MBProgressHub.showLoadingSpinner(sender: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchLoanDetails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchMediclameDetails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.fetchMedicalDetails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.fetchLICDetails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            self.fetchExpenseDetails()
        }
    }
    func fetchLoanDetails() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objCommonSearchViewModel.totalAmount = 0
        objLoanDetails.fetchDataByName(memberName: txtName.text!) { (result) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            if self.objCommonSearchViewModel.arrLoanDetail.count > 0 {
                for i in 0...self.objCommonSearchViewModel.arrLoanDetail.count - 1 {
                    let data = self.objCommonSearchViewModel.arrLoanDetail[i]
                    if let price = data["totalAmount"] {
                        self.objCommonSearchViewModel.totalAmount = self.objCommonSearchViewModel.totalAmount  + Double(price as! String)!
                    }
                }
                self.tblSearch.reloadData()
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func fetchMedicalDetails() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMedicalQuery.fetchDataByName(memberName: txtName.text!) { (result) in
            self.objCommonSearchViewModel.arrMedicalDetail = result
            MBProgressHub.dismissLoadingSpinner(self.view)
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }

        if objCommonSearchViewModel.arrMedicalDetail.count > 0 {
            for i in 0...objCommonSearchViewModel.arrMedicalDetail.count - 1 {
                let data = objCommonSearchViewModel.arrMedicalDetail[i]
                if let price = data["amount"] {
                    objCommonSearchViewModel.totalAmount = objCommonSearchViewModel.totalAmount  + Double(price as! String)!
                }
            }
            tblSearch.reloadData()
        }
    }
    func fetchLICDetails() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserLICDetailsQuery.fetchDataByName(name: txtName.text!) { (result) in
            self.objCommonSearchViewModel.arrLICDetail = result
            MBProgressHub.dismissLoadingSpinner(self.view)
            if self.objCommonSearchViewModel.arrLICDetail.count > 0 {
                for i in 0...self.objCommonSearchViewModel.arrLICDetail.count - 1 {
                    let data = self.objCommonSearchViewModel.arrLICDetail[i]
                    var totalPrice:Double = 0
                    if let price = data["amount"] {
                        if let month = data["months"] {
                            totalPrice = Double(price as! String)! * Double(month as! String)!
                        }
                        self.objCommonSearchViewModel.totalAmount = self.objCommonSearchViewModel.totalAmount  + Double(totalPrice)
                    }
                }
                self.tblSearch.reloadData()
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func  fetchExpenseDetails() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserExpense.fetchDataByName(sponserName: txtName.text!) { (result) in
            self.objCommonSearchViewModel.arrExpenseDetail = result
            MBProgressHub.dismissLoadingSpinner(self.view)
            if self.objCommonSearchViewModel.arrExpenseDetail.count > 0 {
                for i in 0...self.objCommonSearchViewModel.arrExpenseDetail.count - 1 {
                    var data = self.objCommonSearchViewModel.arrExpenseDetail[i]
                    let member = data["shareMemberName"] as! String
                    var totalMember:Int = 1
                    var arrTotalMember = [String]()
                    if member.count > 0 {
                      let arrTotalMember = member.split(separator: ",")
                        if arrTotalMember.count > 0 {
                            totalMember = arrTotalMember.count + 1
                        }
                    }
                   
                    if let price = data["price"] {
                        let newPrice = Double(price as! String)!
                        var selectedPrice:Double = newPrice/Double(totalMember)
                        data["price"] =  "\(selectedPrice.rounded(toPlaces: 2))"
                        self.objCommonSearchViewModel.arrExpenseDetail[i] = data
                        self.objCommonSearchViewModel.totalAmount = self.objCommonSearchViewModel.totalAmount  + Double(selectedPrice.rounded(toPlaces: 2))
                    }
                }
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.tblSearch.reloadData()
                }
            } else {
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    
    func  fetchMediclameDetails() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMediclame.fetchMediclamByName(memberName: txtName.text!) { (result) in
            self.objCommonSearchViewModel.arrMediclameDetail = result
            MBProgressHub.dismissLoadingSpinner(self.view)
            if self.objCommonSearchViewModel.arrMediclameDetail.count > 0 {
                for i in 0...self.objCommonSearchViewModel.arrMediclameDetail.count - 1 {
                    let data = self.objCommonSearchViewModel.arrMediclameDetail[i]
                    if let price = data["price"] {
                        self.objCommonSearchViewModel.totalAmount = self.objCommonSearchViewModel.totalAmount  + Double(price as! String)!
                    }
                }
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    self.tblSearch.reloadData()
                }
            }

        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    
    
    
    func getMemberName() {
        if arrMemberList.count <= 0 {
            AllMemberList.shared.getMemberList { (result) in
                if arrMemberList.count <= 0 {
                    Alert().showAlert(message: "you can't be search because you don't enter any member, please enter the member and entrys then only you can search detail", viewController: self)
                }
                else {
                    self.objCommonSearchViewModel.arrNameList = AllMemberList.shared.getNameArray()
                }
            }

        }else {
            objCommonSearchViewModel.arrNameList = AllMemberList.shared.getNameArray()
        }
    }
    func memberName() {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: objCommonSearchViewModel.arrNameList, viewController: self) { (selectedValue) in
            self.txtName.text = selectedValue
            self.fetchSearchData()
        }
    }
}

