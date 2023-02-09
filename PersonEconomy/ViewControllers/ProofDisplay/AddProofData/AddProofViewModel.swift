//
//  AddProofViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/11/21.
//

import UIKit

class AddProofViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrTitle = ["Bill Name","Date","Total Amount",""]
    var arrDescription = ["","","",""]
    var imageData = Data()
    var imageSelected:Bool = false
    var objImagePickerViewModel = ImagePickerViewModel()
    var lastid:Int = 0
    var isdataPresent:Bool = false
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Add Proof"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(AddProofViewController(), action: #selector(AddProofViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension AddProofViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddProofViewModel.arrTitle.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "AddRecipesTableViewCell") as! AddRecipesTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
            cell.lblTitle.text = objAddProofViewModel.arrTitle[indexPath.row]
            cell.txtDescription.tag = indexPath.row
            cell.txtDescription.delegate = self
            cell.btnSelection.tag = indexPath.row
            cell.txtDescription.text = objAddProofViewModel.arrDescription[indexPath.row]
            cell.btnCall.isHidden = true
            if indexPath.row == 1 {
                cell.imgDown.isHidden = false
                cell.btnSelection.isHidden = false
                if cell.txtDescription.text == "" {
                    cell.txtDescription.text = kSelectOption
                }
            } else {
                cell.imgDown.isHidden = true
                cell.btnSelection.isHidden = true
            }
            if cell.lblTitle.text == "Total Amount" {
                cell.txtDescription.keyboardType = .numberPad
            }else {
                cell.txtDescription.keyboardType = .default
            }
            if indexPath.row == 0 && isfromEdit {
                cell.txtDescription.isEnabled = false
            } else {
                cell.txtDescription.isEnabled = true
            }
            cell.selectedIndex = {[weak self] value in
                self?.pickDate(index: value)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
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
        }
    }
}
extension AddProofViewController {
    func fetchUserLastid() {
        objUserDataQuery.getRecordsCount { (record) in
            self.objAddProofViewModel.lastid = record + 1
        }
    }
    func fetchByName(name:String) {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserDataQuery.fetchDataByName(name: name) { (data) in
            if data.count > 0 {
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.objAddProofViewModel.isdataPresent = true
            } else {
                self.objAddProofViewModel.isdataPresent = false
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func takeImageFromCamera() {
        objAddProofViewModel.objImagePickerViewModel.openCamera(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        objAddProofViewModel.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            if success.0 == true {
                self!.objAddProofViewModel.imageSelected = true
                self!.objAddProofViewModel.imageData = success.1
            } else {
                Alert().showAlert(message: "your Image is not saved please try again", viewController: self!)
            }
        }
    }
    func takeImageFromGallery() {
        objAddProofViewModel.objImagePickerViewModel.openGallery(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        objAddProofViewModel.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            DispatchQueue.main.async {
                if success.0 == true {
                    self!.objAddProofViewModel.imageSelected = true
                    self!.objAddProofViewModel.imageData = success.1
                }else {
                    Alert().showAlert(message: "your Image is not saved please try again", viewController: self!)
                }
            }
        }
    }
    func validation() -> Bool {
        if objAddProofViewModel.arrDescription[0].isEmpty {
            Alert().showAlert(message: "please provide name", viewController: self)
            return false
        }
        if objAddProofViewModel.arrDescription[1].isEmpty {
            Alert().showAlert(message: "please provide date", viewController: self)
            return false
        }
        if objAddProofViewModel.arrDescription[2].isEmpty {
            Alert().showAlert(message: "please enter price", viewController: self)
            return false
        }
        if self.objAddProofViewModel.imageData == nil {
            Alert().showAlert(message: "please select image", viewController: self)
        }
        return true
    }
    
    func pickDate(index:Int) {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedValue) in
            let strSelectedvalue:String = self.dateFormatter.string(from: selectedValue)
            self.objAddProofViewModel.arrDescription[index] = strSelectedvalue
            self.tblDisplayData.reloadData()
        }
    }
    
    func saveData()  {
        if objAddProofViewModel.isdataPresent  {
            Alert().showAlert(message: "This name alreay exist please provide other one", viewController: self)
            return
        }
        let data = objUserDataQuery.saveinDataBase(userDataId: objAddProofViewModel.lastid, name: objAddProofViewModel.arrDescription[0].capitalizingFirstLetter(), startDate: "", endDate: objAddProofViewModel.arrDescription[1], image: objAddProofViewModel.imageData, userMedicalId: struserMedicalId, price: objAddProofViewModel.arrDescription[2])
        if data {
            setAlertWithCustomAction(viewController: self, message: "data saved", ok: { (isSuccess) in
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isFailed) in
            }
        }
    }
    
    func updateDataBase() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserDataQuery.updateMember(userDataId: dicDataForEdit["userDataId"] as! Int, startDate: "", endDate: objAddProofViewModel.arrDescription[1], image: objAddProofViewModel.imageData, userMedicalId: struserMedicalId, price: objAddProofViewModel.arrDescription[2]) { (isSuccess) in
            setAlertWithCustomAction(viewController: self, message: "data updated", ok: { (isSuccess) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isFailed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
}
extension AddProofViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objAddProofViewModel.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        objAddProofViewModel.arrDescription[textField.tag] = textField.text! + string
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.fetchByName(name: textField.text!.capitalizingFirstLetter())
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblDisplayData.reloadData()
        return true
    }
}
