//
//  ForgotPasswordViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 17/03/21.
//

import UIKit


class ForgotPasswordViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Forgot Password"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(ForgotPasswordViewController(), action: #selector(ForgotPasswordViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension ForgotPasswordViewController: UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }
            }
        if textField.tag == 1 {
            if textField.text!.count > 9 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        return true
    }
}
extension ForgotPasswordViewController {
    func configData() {
        objForgotPassword.setHeaderView(headerView: viewHeader)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        txtEmail = setCustomSignUpTextField(self: txtEmail, placeHolder: txtEmail.placeholder!, isBorder: false)
        txtMobileNumber = setCustomSignUpTextField(self: txtMobileNumber, placeHolder: txtMobileNumber.placeholder!, isBorder: false)
        lblSepratorEmail.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorMobile.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnSubmit.setUpButton()
    }
    func getDataFromDB(number:String,success successBlock:@escaping ((Bool) -> Void))  {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserProfileDatabaseQuerySetUp.fetchData() { (result) in
            self.arrSelectedData = result
            MBProgressHub.dismissLoadingSpinner(self.view)
            if self.arrSelectedData.count > 0 {
                successBlock(true)
            } else {
                successBlock(false)
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func validation() -> Bool {
        if txtEmail.text == "" {
            Alert().showAlert(message: "Please provide email id", viewController: self)
            return false
        }
        if !isValidEmail(emailStr: txtEmail.text!) {
            Alert().showAlert(message: "Please provide email id", viewController: self)
            return false
        }
        if txtMobileNumber.text!.count < 10 || txtMobileNumber.text == "" {
            Alert().showAlert(message: "Please provide mobile number", viewController: self)
            return false
        }
        return true
    }
    
    func setupForgotPasswordData(password:String)  {
        self.scheduleNotification(password: password)
        setAlertWithCustomAction(viewController: self, message: "Password notification will come", ok: { (isSuccess) in
            self.dismiss(animated: true, completion: nil)
        }, isCancel: false) { (isSuccess) in
        }
    }
    
    func scheduleNotification(password: String) {
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Forgot Password"
        content.sound = UNNotificationSound.default
        content.body = "Your password is: " + password
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                Alert().showAlert(message: error.localizedDescription, viewController: self)
            }
        }
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: categoryIdentifire,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            appDelegate.notificationCenter.setNotificationCategories([category])
    }
}
