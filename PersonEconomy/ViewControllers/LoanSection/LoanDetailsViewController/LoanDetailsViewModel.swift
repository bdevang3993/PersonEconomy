//
//  LoanDetailsViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 06/02/21.
//

import UIKit

class LoanDetailsViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Loan Details"
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LoanDetailsViewController(), action: #selector(LoanDetailsViewController.backCliked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension LoanDetailsViewController {
    func configureData() {
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblDetails.delegate = self
        self.tblDetails.dataSource = self
    }
    func fetchDataFromDataBase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objLoanEntryPerMonth.fetchAllDataById(loanId: strLoanId) { (result) in
            self.arrLoanDetails = result
            MBProgressHub.dismissLoadingSpinner(self.view)
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
        totalAmount = self.calaculateTotalAmount()
        tblDetails.reloadData()
    }
    func delteAllData() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        var strloanid:String = ""
        for i in 0...arrLoanDetails.count - 1 {
            let objData = arrLoanDetails[i]
            strloanid = objData["loanId"] as! String
            objLoanEntryPerMonth.deleteEntryDetails(loanId: strloanid) { (isSuccess) in
            }
        }
        objLoanDetails.deleteLoanDetail(loanId: strloanid) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Data Deleted", ok: { (sucess) in
                self.updatedata!()
                self.dismiss(animated: true, completion: nil)
                MBProgressHub.dismissLoadingSpinner(self.view)
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    func calaculateTotalAmount() -> Int {
        var totalAmount:Int = 0
        for loanDetail in arrLoanDetails {
            let value:String = loanDetail["amount"] as! String
            totalAmount = totalAmount + Int(value)!
        }
        return totalAmount
    }
    
}

extension LoanDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return arrLoanDetails.count
        } else {
           return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tblDetails.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            if UIDevice.current.userInterfaceIdiom == .pad {
                cell.lblItemName.textAlignment = .left
            } else {
                cell.lblItemName.textAlignment = .center
            }
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tblDetails.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = "\(totalAmount)"
            cell.selectionStyle = .none
            return cell
            
        }else {
            let cell = tblDetails.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            let objData = arrLoanDetails[indexPath.row]
            cell.lblDeduction.text = (objData["amount"] as! String)
            cell.lblBankName.text = strBankName
            cell.lblDateofPay.text = (objData["date"] as! String)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
        } else {
            let objLoanDescription:LoanDescriptionViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(identifier: "LoanDescriptionViewController") as! LoanDescriptionViewController
            objLoanDescription.arrLoanDetails = arrLoanDetails[indexPath.row]
            objLoanDescription.strBankName = strBankName
            objLoanDescription.modalPresentationStyle = .overFullScreen
            objLoanDescription.clUpdateData = {[weak self] in
                self?.fetchDataFromDataBase()
            }
            self.present(objLoanDescription, animated: true, completion: nil)
        }

    }
    
    
}
