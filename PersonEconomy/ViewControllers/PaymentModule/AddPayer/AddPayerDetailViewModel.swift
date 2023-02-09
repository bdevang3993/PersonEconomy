//
//  AddPayerDetailViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import UIKit

class AddPayerDetailViewModel: NSObject {
    var headerViewXib:CommanView?
    var payerDetailsQuery = PayerDetailsQuery()
    var objPayerData = PayerData(strName: "", strURL: "", id: 0)
    var strURlLink:String = ""
    var newId:Int = -1
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Payer Detail"
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddPayerDetailViewController(), action: #selector(AddPayerDetailViewController.backClicked), for: .touchUpInside)
        //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
      
    }
}

extension AddPayerDetailViewController {
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            DispatchQueue.main.async {
                //self?.setUpQRAPI(qrImage: value)
                let data = value.parseQR()
                if data.count > 0 {
                    self!.objAddPayerDetailViewModel.strURlLink = data[0]
                    self!.qrImage.image = value
                } else {
                    Alert().showAlert(message: "Didn't get image with QrCode please try again", viewController: self!)
                }
              //  self!.strUpiLink = data[0]
            }
        }
    }
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            DispatchQueue.main.async {
                let data = value.parseQR()
                if data.count > 0 {
                    self!.objAddPayerDetailViewModel.strURlLink = data[0]
                    self!.qrImage.image = value
                } else {
                    Alert().showAlert(message: "Didn't get image with QrCode please try again", viewController: self!)
                }
                //self!.strUpiLink = data[0]
            }
        }
    }
    func alertForImage() {
        let alertController = UIAlertController(title: "Demo", message: "please select one option", preferredStyle: .alert)
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
    func fetchId() {
        objAddPayerDetailViewModel.payerDetailsQuery.getRecordsCount { (id) in
            self.objAddPayerDetailViewModel.newId = id + 1
        }
    }
    
    
    func saveInDatabase() {
        MBProgressHub.dismissLoadingSpinner(self.view)
        let name = txtBusinessName.text?.capitalizingFirstLetter()
        _ = objAddPayerDetailViewModel.payerDetailsQuery.fetchAllDataByName(name: name!) { (arrAllData) in
            if arrAllData.count > 0 {
                Alert().showAlert(message: "Business name already exist please update or give another name", viewController: self)
            } else {
                self.saveQuery(name: name!)
            }
        } failure: { (isFailed) in
            self.saveQuery(name: name!)
        }
    }
    
    
    func saveQuery(name:String) {
        _ = self.payerDetailsQuery.saveinDataBase(id: self.objAddPayerDetailViewModel.newId, strName: name, strURL: self.objAddPayerDetailViewModel.strURlLink)
        DispatchQueue.main.async {
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.updateAllData!()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddPayerDetailViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
