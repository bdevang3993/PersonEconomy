//
//  LICDescriptionViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit
import SBPickerSelector

class LICDescriptionViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrAllTitle = ["Date","Policy Number","Bill Number","Amount","Agent Name","Agent Number","Paied Date"]
    var arrDescription = ["","","","","","",""]
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
        headerViewXib?.btnBack.addTarget(LICDescriptionViewController(), action: #selector(LICDescriptionViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension LICDescriptionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objLICDescriptionViewModel.arrAllTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLICDescription.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.txtDescription.tag = indexPath.row
        cell.btnSelection.tag = indexPath.row
        cell.selectedIndex = {[weak self] value in
            self?.setupPickerDate(selectedIndex: value)
        }
        let title:String = objLICDescriptionViewModel.arrAllTitle[indexPath.row]
        cell.lblTitle.text = title.capitalizingFirstLetter()
        cell.txtDescription.text = objLICDescriptionViewModel.arrDescription[indexPath.row]
        
        if title == "Paied Date" {
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
            if  cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
            
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
        }
        if title == "Agent Number" {
            cell.btnCall.isHidden = false
        } else {
            cell.btnCall.isHidden = true
        }
        if title == "Date" || title == "Policy Number" || title == "Amount" || title == "Agent Name" || title == "Agent Number" {
            cell.txtDescription.isEnabled = false
        } else {
            cell.txtDescription.isEnabled = true
            cell.txtDescription.delegate = self
        }
       
        cell.callclicked = {[weak self] in
            self?.callPerson()
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension LICDescriptionViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblLICDescription.reloadData()
        return true
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objLICDescriptionViewModel.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        objLICDescriptionViewModel.arrDescription[textField.tag] = textField.text! + string
        return true
    }
}
extension LICDescriptionViewController {
    
    func callPerson() {
        objLICDescriptionViewModel.arrDescription[5].makeACall()
    }
    
    func configureData() {
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        btnSave.setUpButton()
        self.getAgentNumber()
        self.setUpAllData()
        self.tblLICDescription.delegate = self
        self.tblLICDescription.dataSource = self
        if UIDevice.current.userInterfaceIdiom == .pad {
                  viewBtnSubmit.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewBtnSubmit.frame.size.height = (60.0 * (screenWidth/320.0))
              }
    }
    func setupPickerDate(selectedIndex:Int) {
        let date = Date()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
        }.set { values in
            if let values = values as? [Date] {
                self.objLICDescriptionViewModel.arrDescription[selectedIndex] = self.dateFormatter.string(from: values[0])
                self.tblLICDescription.reloadData()
            }
        }.present(into: self)
    }
    func getAgentNumber() {
        objUserLICDetailsQuery.fetchLICDataUsingID(policyNumber: dicLICDescription["policyNumber"] as! String) { (result) in
            if result.count > 0 {
                let newData = result[0]
                if let name = newData["personName"] {
                    self.objLICDescriptionViewModel.arrDescription[4] = name as! String
                }
                if let number = newData["personNumber"]{
                    self.objLICDescriptionViewModel.arrDescription[5] = number as! String
                }
                self.tblLICDescription.reloadData()
            }
        } failure: { (isFailed) in
        }
    }
    func setUpAllData() {
        objLICDescriptionViewModel.arrDescription[0] = dicLICDescription["date"] as! String
        objLICDescriptionViewModel.arrDescription[1] = dicLICDescription["policyNumber"] as! String
        objLICDescriptionViewModel.arrDescription[2] = dicLICDescription["billNumber"] as! String
        objLICDescriptionViewModel.arrDescription[3] = dicLICDescription["amount"] as! String
        objLICDescriptionViewModel.arrDescription[6] = dicLICDescription["payedDate"] as! String
    }
    
    func validation() -> Bool {
        if objLICDescriptionViewModel.arrDescription[2] == "" {
            Alert().showAlert(message: "please provide bill number", viewController: self)
            return false
        }
        return true
    }
    
    func updateinDatabase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objEntryPerMonth.updateEntryDetails(policyNumber: objLICDescriptionViewModel.arrDescription[1], date: objLICDescriptionViewModel.arrDescription[0], amount: objLICDescriptionViewModel.arrDescription[3], billNumber: objLICDescriptionViewModel.arrDescription[2], paiedDate: objLICDescriptionViewModel.arrDescription[6]) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "data updated successfully", ok: { (success) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.cdUpdateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (failed) in
                
            }
        }
    }
}
