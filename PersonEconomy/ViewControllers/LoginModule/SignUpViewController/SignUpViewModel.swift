//
//  SignUpViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 06/01/21.
//

import UIKit
import SBPickerSelector
import CoreData
class SignUpViewModel: NSObject {
    
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView,isfromSignUp:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
         headerView.frame = headerViewXib!.bounds
        if isfromSignUp {
            headerViewXib!.lblTitle.text = "Sign Up"
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib!.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(SignUpViewController(), action: #selector(SignUpViewController.backClicked), for: .touchUpInside)
          //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        }else {
            headerViewXib!.lblTitle.text = "Profile"
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "drawer")
            headerViewXib!.lblBack.isHidden = true
           // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
            headerViewXib?.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(SignUpViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension SignUpViewController {
    func configureData() {
        txtName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtContactNumber.delegate = self
        
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCornerSetUp.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        txtName = setCustomSignUpTextField(self: txtName, placeHolder: txtName.placeholder!, isBorder: false)
        txtBirthDay = setCustomSignUpTextField(self: txtBirthDay, placeHolder: txtBirthDay.placeholder!, isBorder: false)
        txtGender = setCustomSignUpTextField(self: txtGender, placeHolder: txtGender.placeholder!, isBorder: false)
        txtContactNumber = setCustomSignUpTextField(self: txtContactNumber, placeHolder: txtContactNumber.placeholder!, isBorder: false)
        txtEmail = setCustomSignUpTextField(self: txtEmail, placeHolder: txtEmail.placeholder!, isBorder: false)
        txtPassword = setCustomSignUpTextField(self: txtPassword, placeHolder: txtPassword.placeholder!, isBorder: false)
        txtRepassword = setCustomSignUpTextField(self: txtRepassword, placeHolder: txtRepassword.placeholder!, isBorder: false)
        btnSubmit.setUpButton()
        self.setUpViewAsperTheam()
        if UIDevice.current.userInterfaceIdiom == .pad {
            btnSubmit.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            btnSubmit.frame.size.height = (60.0 * (screenWidth/320.0))
        }
        if isFromSignUp {
            viewHeaderTbl.frame.size.height = 900
            if UIDevice.current.userInterfaceIdiom == .pad {
                viewHeaderTbl.frame.size.height = 1050
            }
            layoutConstraintPasswordHeight.constant = 64.0
            layoutConstraintSubmitTop.constant = 60.0
            btnSubmit.setTitle("SUBMIT", for: .normal)
            layOutConstriantTopTerms.constant = 30.0
            layoutConstraintheightTerms.constant = 40.0
            txtContactNumber.isEnabled = true
            lblTermsAndCondition.isHidden = false
            btnTermsAndCondition.isHidden = false
            self.searchFilesDocumentsFolder(Extension: "sqlite")
            if isDataBaseAvailable {
                setAlertWithCustomAction(viewController: self, message:kRegisterOnePerson, ok: { (isSuccess) in
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isSuccess) in
                }

            }
            objUserProfile.getRecordsCount { (isSuccess) in
                if isSuccess  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                        setAlertWithCustomAction(viewController: self, message:kRegisterOnePerson, ok: { (isSuccess) in
                            self.dismiss(animated: true, completion: nil)
                        }, isCancel: false) { (isSuccess) in
                        }
                    }
                }
            }
  
        } else {
            
            layOutConstriantImageWidth.constant = 0
            lblYearsMessage.text = ""
            layoutConstraintyearHeight.constant = 0
            txtContactNumber.isEnabled = false
            viewHeaderTbl.frame.size.height = 680
            if UIDevice.current.userInterfaceIdiom == .pad {
                viewHeaderTbl.frame.size.height = 800
            }
            layoutConstraintPasswordHeight.constant = 0.0
            layoutConstraintSubmitTop.constant = -30.0
            btnSubmit.setTitle("UPDATE", for: .normal)
            
            layOutConstriantTopTerms.constant = 0.0
            layoutConstraintheightTerms.constant = 0.0
            lblTermsAndCondition.isHidden = true
            btnTermsAndCondition.isHidden = true
            
        }
    }
    
    func setUpViewAsperTheam() {
        lblnameSeprator.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorBirthDay.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorGender.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorNumber.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorEmail.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSeparatorPassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSeparatorRePassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        imgBirthDown.tintColor = hexStringToUIColor(hex: strTheamColor)
        imgDownGender.tintColor = hexStringToUIColor(hex: strTheamColor)
    }
    
    //MARK:- Picker View
    func setUpPickerString(arrPickerData:[String],viewController:UIViewController)  {
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: arrPickerData).cancel {
            }.set { values in
                if let values = values as? [String] {
                    //self.objExpenseViewModel.arrDescription[2] = values[0]
                    self.txtGender.text = values[0]
                    self.tblDisplayData.reloadData()
                }
        }.present(into: viewController)
    }
    func setUpPickerDate() -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -4
        let date = Date()
        let newDate = calendar.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    
    func setupPickerDate(viewController:UIViewController) {
        let date = setUpPickerDate()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
        }.set { values in
            if let values = values as? [Date] {
                let birthDate = self.dateFormatter.string(from: values[0])
                self.txtBirthDay.text = birthDate
                self.imgCheckMark.image = UIImage(named: "checked")
                self.tblDisplayData.reloadData()
            }
        }.present(into: viewController)
    }
    
    func validatation() -> Bool {
        
        if txtName.text!.count <= 0 {
            Alert().showAlert(message: "please provide name", viewController: self)
            return false
        }
        else if self.txtEmail.text!.count > 0 && !isValidEmail(emailStr: txtEmail.text!) {
            Alert().showAlert(message: "please provide valied Email Id", viewController: self)
            return false
        }
        else if txtPassword.text!.count <= 0{
            Alert().showAlert(message: "please provide password", viewController: self)
            return false
        }
        else if txtPassword.text!.count < 6 {
            Alert().showAlert(message: "please provide at least 6 digit password", viewController: self)
            return false
        }
        if isFromSignUp {
            if txtRepassword.text!.count <= 0 {
                Alert().showAlert(message: "please provide password again", viewController: self)
                return false
            }
            else if txtRepassword.text != txtPassword.text {
                Alert().showAlert(message: "password does not match please re-enter", viewController:self)
                return false
            }
            let image = UIImage(named: "unChecked")
            let compare = imgCheckMark.image?.isEqualToImage(image: image!)
            if compare! {
                Alert().showAlert(message: "If you are more then 4 years then please click on check box on your age is more then 4 years", viewController: self)
                return false
            }
        }
        return true
    }
    
    func moveToTermsAndCondition() {
        let objTerms:TermsAndConditionViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        objTerms.modalPresentationStyle = .overFullScreen
        self.present(objTerms, animated: true, completion: nil)
    }
    
     func searchFilesDocumentsFolder(Extension: String) {

        let documentsUrl =  FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!

            do {
                let directoryUrls = try  FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
                let Files = directoryUrls.filter{ $0.pathExtension == Extension }.map{ $0.lastPathComponent }
                print("\(Extension) FILES:\n" + Files.description)
                
            } catch let error as NSError {
            }
        }
}
extension SignUpViewController: UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }
            }
        
        if textField.tag == 3 {
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        return true
    }
}
