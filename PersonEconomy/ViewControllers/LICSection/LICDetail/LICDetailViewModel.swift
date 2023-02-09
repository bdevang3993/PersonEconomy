//
//  LICDetailViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit

class LICDetailViewModel: NSObject {
    var headerViewXib:CommanView?
    var strTotalAmount:String = ""
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "LIC Description"
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LICDetailViewController(), action: #selector(LICDetailViewController.backCliked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension LICDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return arrDisplayData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblLICDetails.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 2 {
            let cell = tblLICDetails.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = objLICDetailViewModel.strTotalAmount
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblLICDetails.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            let objData = arrDisplayData[indexPath.row]
            if let date = objData["date"] {
                cell.lblDateofPay.text = (date as! String)
            }
            if let billNumber = objData["billNumber"] {
                cell.lblBankName.text = (billNumber as! String)
            }
            if let amount = objData["amount"] {
                cell.lblDeduction.text = (amount as! String)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objLICDescription:LICDescriptionViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LICDescriptionViewController") as! LICDescriptionViewController
        objLICDescription.dicLICDescription = arrDisplayData[indexPath.row]
        objLICDescription.modalPresentationStyle = .overFullScreen
        objLICDescription.cdUpdateData = {[weak self] in
            self!.fetchDataFromDataBase(strPolicyNumber: self!.strpolicyNumber)
        }
        self.present(objLICDescription, animated: true, completion: nil)
    }
}
extension LICDetailViewController {
    
    func configureData() {
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        self.fetchDataFromDataBase(strPolicyNumber: strpolicyNumber)
        objLICDetailViewModel.strTotalAmount = "\(self.calaculateTotalAmount())"
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblLICDetails.delegate = self
        self.tblLICDetails.dataSource = self
        self.tblLICDetails.tableFooterView = UIView()
    }
    
    func fetchDataFromDataBase(strPolicyNumber:String) {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objLICEntryPerMonthQuery.fetchAllDataById(policyNumber: strPolicyNumber) { (result) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.arrDisplayData = result
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func calaculateTotalAmount() -> Int {
        var totalAmount:Int = 0
        for licDetail in arrDisplayData {
            let value:String = licDetail["amount"] as! String
            totalAmount = totalAmount + Int(value)!
        }
        return totalAmount
    }
    
    func deleteData()  {
        setAlertWithCustomAction(viewController: self, message: "Are you sure delete this entrys?", ok: { (success) in
            DispatchQueue.main.async {
                self.deleteAllData()
            }
        }, isCancel: false) { (failure) in
        }

    }
    func deleteAllData() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        var strpolicyNumber:String = ""
        for i in 0...arrDisplayData.count - 1 {
            let objData = arrDisplayData[i]
            strpolicyNumber = objData["policyNumber"] as! String
            objLICEntryPerMonthQuery.deleteEntryDetails(policyNumber: objData["policyNumber"] as! String) { (isSuccess) in
            }
        }
        self.objUserLICDetailsQuery.deleteLICDetail(policyNumber:strpolicyNumber) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Data Deleted", ok: { (isSuccess) in
                self.csUpdateData!()
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isSuccess) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
       
    }
}
