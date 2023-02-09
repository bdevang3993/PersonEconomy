//
//  LogoAndNameViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/03/21.
//

import UIKit

class LogoAndNameViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Logo"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(LogoAndNameViewController(), action: #selector(LogoAndNameViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension LogoAndNameViewController {
    
    func fetchId() {
        payerDetailsQuery.getRecordsCount { (id) in
            self.newId = id + 1
        }
        self.payerDetailsQuery.fetchAllDataByName(name: "self") { (result) in
            self.arrPayerData = result
        } failure: { (failed) in
        }

    }
    
    func setConfigureData() {
        txtCompanyName.setLeftPaddingPoints(10.0)
        txtCompanyName.layer.borderWidth = 1.0
        txtCompanyName.layer.borderColor = UIColor.white.cgColor
        txtNumber.setLeftPaddingPoints(10.0)
        txtNumber.layer.borderWidth = 1.0
        txtNumber.layer.borderColor = UIColor.white.cgColor
        txtCompanyName.delegate = self
        txtNumber.delegate = self
        objLogoViewModel.setHeaderView(headerView: self.viewHeader)
        txtCompanyName.textColor = hexStringToUIColor(hex: strTheamColor)
        lblCompanyLogo.textColor = hexStringToUIColor(hex: strTheamColor)
        lblQRCode.textColor = hexStringToUIColor(hex: strTheamColor)
        txtNumber.textColor = hexStringToUIColor(hex: strTheamColor)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        btnSave.setUpButton()
        self.fetchId()
        let userDefault = UserDefaults.standard
        if userDefault.value(forKey: kCompanyName) != nil{
            self.txtCompanyName.text = (userDefault.value(forKey: kCompanyName) as! String)
        }
        if userDefault.value(forKey: kContactNumber) != nil{
            self.txtNumber.text = (userDefault.value(forKey: kContactNumber) as! String)
        }
        if  userDefault.value(forKey: kLogo) != nil {
            self.imgView.image = getSavedImage(named: kLogo)
        } else {
            self.imgView.image = UIImage(named: "Logo")
        }
        if  userDefault.value(forKey: kQRCode) != nil {
            self.imgQRCode.image = getSavedImage(named: kQRCode)
        }
        
    }
    func pickImage() {
        objImagePickerViewModel.openGallery(viewController: self)
        objImagePickerViewModel.selectedImageFromGalary = {[weak self] selectedImage in
            self?.imgView.image = selectedImage
        }
    }
    func saveImage(image: UIImage,name:String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            return true
        } catch {
            Alert().showAlert(message: error.localizedDescription, viewController: self)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    func saveInQRDatabase()  {
        if self.arrPayerData.count > 0 {
            let data = arrPayerData[0]
            self.payerDetailsQuery.update(id: data.id, name: "self", strUrl: self.strURlLink)
        } else {
            self.payerDetailsQuery.saveinDataBase(id: self.newId, strName: "self", strURL: self.strURlLink)
        }
        
    }
}
extension LogoAndNameViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }
            }
        
        if textField == txtNumber {
            if textField.text!.count > 9 {
                txtNumber.resignFirstResponder()
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        return true
    }
}
