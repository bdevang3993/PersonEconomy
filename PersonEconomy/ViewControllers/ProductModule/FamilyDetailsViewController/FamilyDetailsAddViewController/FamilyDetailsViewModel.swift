//
//  FamilyDetailsViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import IQKeyboardManagerSwift
class FamilyDetailsViewModel: NSObject {
    var headerViewXib:CommanView?
    var memberid:Int = 0
    var isFromEdit:Bool = false
    func setHeaderView(headerView:UIView,isfromSignUp:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromEdit {
            headerViewXib!.lblTitle.text = "Edit  Member"
        } else {
            headerViewXib!.lblTitle.text = "Add  Member"
        }
        
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(FamilyDetailsViewController(), action: #selector(FamilyDetailsViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}

extension FamilyDetailsViewController {
    
    func configureData() {
        txtName.delegate = self
        //txtRelationShip.delegate = self
        txtOccupation.delegate = self
        txtMobileNo.delegate = self
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        imgDown.tintColor = hexStringToUIColor(hex: strTheamColor)
        imgDownOccupation.tintColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        txtName = setCustomSignUpTextField(self: txtName, placeHolder: txtName.placeholder!, isBorder: false)
        txtOccupation = setCustomSignUpTextField(self: txtOccupation, placeHolder: txtOccupation.placeholder!, isBorder: false)
        txtRelationShip = setCustomSignUpTextField(self: txtRelationShip, placeHolder: txtRelationShip.placeholder!, isBorder: false)
        txtMobileNo = setCustomSignUpTextField(self: txtMobileNo, placeHolder: txtMobileNo.placeholder!, isBorder: false)
        lblSepratorName.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorRelation.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorOccupation.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorNumber.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        btnSubmit.setUpButton()
        self.getMemberfromDB()
        self.getMemberId()
        if isFromDetails {
            self.btnDelete.isHidden = false
            self.setUpDisplayData()
            btnSubmit.setTitle("UPDATE", for: .normal)
            txtName.isEnabled = false
        } else {
            self.btnDelete.isHidden = true
            btnSubmit.setTitle("SUBMIT", for: .normal)
            txtName.isEnabled = true
        }
    }
    
    func setUpDisplayData() {
        if let name = dicAllFamilyDetails["name"] {
            txtName.text = (name as! String)
        }
        if let occupation = dicAllFamilyDetails["occupation"] {
            txtOccupation.text = (occupation as! String)
        }
        if let relationShip = dicAllFamilyDetails["relationShip"] {
            txtRelationShip.text = (relationShip as! String)
        }
        if let id = dicAllFamilyDetails["userid"] {
            objFamilyDetailsViewModel.memberid = Int(id as! String)!
        }
        if let number = dicAllFamilyDetails["number"] {
            txtMobileNo.text = (number as! String)
        }
        btnRelationShip.isEnabled = false
        txtRelationShip.isEnabled = false
        imgDown.isHidden = true
    }
    
    func validation() -> Bool {
        if txtName.text!.count < 0 || txtName.text!.isEmpty {
            Alert().showAlert(message: "please provide member name", viewController: self)
            return false
        }
        if txtOccupation.text!.count < 0 || txtOccupation.text!.isEmpty {
            Alert().showAlert(message: "please provide Occupation", viewController: self)
            return false
        }
        if txtRelationShip.text!.count < 0 || txtRelationShip.text!.isEmpty {
            Alert().showAlert(message: "please provide RelationShip", viewController: self)
            return false
        }
//        if txtMobileNo.text!.count < 0 || txtMobileNo.text!.isEmpty  {
//            Alert().showAlert(message: "please provide Contact No", viewController: self)
//            return false
//        }
        if !validatePhoneNumber(value: txtMobileNo.text!) && txtMobileNo.text!.count > 0 {
            Alert().showAlert(message: "please provide 10 digit mobile number", viewController: self)
            return false
        }
        if !isFromDetails {
            if objFamilyDetailsViewModel.memberid > 1 {
                if self.checkDataExist(number: txtMobileNo.text!) {
                    Alert().showAlert(message: "This number alreday exist please provide new nubmer", viewController: self)
                    return false
                }
            }
        }
        return true
    }
    
    @objc func setupPickerData() {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: ["Grand Father","Grand Motehr","Father","Mother","Brother","Bhabhi","Sister","Son","Uncle","Aunty","Friend","Customer","other","Self"], viewController: self) { (value) in
            DispatchQueue.main.async {
                self.txtRelationShip.text = value
            }
        }
    }
    
    @objc func setupPickerForOccupationData() {
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: ["Business","Self-employee","Student"], viewController: self) { (value) in
            DispatchQueue.main.async {
                self.txtOccupation.text = value
            }
        }
    }
    
    
    
    func resignAllTextField() {
        self.txtName.resignFirstResponder()
        self.txtOccupation.resignFirstResponder()
        self.txtMobileNo.resignFirstResponder()
    }
}
extension FamilyDetailsViewController {
    
    func getMemberId() {
        objFamilyMember.getLastId { (memberid) in
            self.objFamilyDetailsViewModel.memberid =  memberid + 1
        }
    }
    func checkDataExist(number:String) -> Bool {
       let array = convertToJSONArray(moArray: objFamilyMember.faimalyMember)
        for data in array {
            let checknumber = data["number"]
            if number == checknumber as! String {
                return true
            }
        }
        return false
    }
    
    func getMemberfromDB() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objFamilyMember.fetchData { (result) in
            arrMemberList = result
            MBProgressHub.dismissLoadingSpinner(self.view)
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    
    func addMemberInDB() {
        let name = removeWhiteSpace(strData: txtName.text!)
        if arrMemberList.count > 0 {
            for newMemberData in arrMemberList {
                if let name = newMemberData["name"] {
                    if name as! String == txtName.text! {
                        Alert().showAlert(message: "This name is alreday exist please try other name", viewController: self)
                        return
                    }
                }
            }
        }
        let memberAdd = objFamilyMember.saveinDataBase(userid:"\(objFamilyDetailsViewModel.memberid)",name: name, occupation: removeWhiteSpace(strData: txtOccupation.text!), relationShip:removeWhiteSpace(strData: txtRelationShip.text!), number: txtMobileNo.text!)
        if memberAdd {
            taUpdateMember!(true)
            setAlertWithCustomAction(viewController: self, message: "Member added succefully", ok: { (isValied) in
                AllMemberList.shared.getMemberList { (result) in
                    
                }
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isValied) in
            }
        } else {
            Alert().showAlert(message: "Member not added please try again", viewController: self)
        }
    }
    
    func updateMemberInDB() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objFamilyMember.updateMember(userid: "\(objFamilyDetailsViewModel.memberid)", name: txtName.text!, occupation: txtOccupation.text!, relationShip: txtRelationShip.text!, number: txtMobileNo.text!) { (updateMember) in
            setAlertWithCustomAction(viewController: self, message: "Data updated", ok: { (success) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.taUpdateMember!(true)
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                Alert().showAlert(message: "Issue in update the member please try again", viewController: self)
            }
        }
    }
    
    func deletefromDataBase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objFamilyMember.deleteUserExpense(userid: "\(objFamilyDetailsViewModel.memberid)") { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "Member deleted", ok: { (suceess) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.taUpdateMember!(true)
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (failed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
}

extension FamilyDetailsViewController : UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        if textField == txtMobileNo {
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtName.resignFirstResponder()
        }
        return true
    }
}
