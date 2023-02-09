//
//  LoginViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import LocalAuthentication
import CoreData

class LoginViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
           if headerView.subviews.count > 0 {
               headerViewXib?.removeFromSuperview()
           }
           headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
           headerViewXib!.btnHeader.isHidden = true
           headerViewXib!.lblTitle.text = "Login"
           headerViewXib!.imgBack.isHidden = true
           headerView.frame = headerViewXib!.bounds
           headerViewXib!.btnBack.isHidden = true
           headerViewXib?.btnBack.setTitle("", for: .normal)
           headerViewXib!.lblBack.isHidden = true
          // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = .clear//hexStringToUIColor(hex: strTheamColor)
           headerView.addSubview(headerViewXib!)
       }
}
extension ViewController {
    
    func setUpCustomField() {
       txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail = setCustomTextField(self: txtEmail, placeHolder: txtEmail.placeholder!, isBorder: false)
        txtPassword = setCustomTextField(self: txtPassword, placeHolder: txtPassword.placeholder!, isBorder: false)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        DispatchQueue.main.async {
            self.loginViewModel.setHeaderView(headerView: self.viewHeader)
            self.viewDown.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
            self.viewDown.backgroundColor = hexStringToUIColor(hex: strTheamColor)
            self.btnLogin.setUpButton()
           // self.lblSignUp.setCustomLabel()
            //self.lblAccountTitle.setCustomLabel()
            self.lblEmailSeparator.backgroundColor = hexStringToUIColor(hex: CustomColor().labelSepratorColor)
            self.lblPasswordSeprator.backgroundColor = hexStringToUIColor(hex: CustomColor().labelSepratorColor)
        }
    }
    func moveToNextViewController() {
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = initialViewController
    }
    func loginUsingBioMatrix() {
        password = KeychainService.loadPassword()
        email = KeychainService.loadEmail()
        if  password.count > 0 {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (isvalied, error) in
                    if isvalied {
                        DispatchQueue.main.async { [unowned self] in
                            let userDefault = UserDefaults.standard
                            userDefault.setValue(email, forKey: kEmail)
                            userDefault.setValue(password, forKey: kPassword)
                            userDefault.synchronize()
                            self.moveToNextViewController()
                        }
                    }else {
                        DispatchQueue.main.async {
                        Alert().showAlert(message: "\(error.debugDescription)", viewController: self)
                        }
                    }
                })
            }
        } else {
            Alert().showAlert(message: "please we don't have credential so first time login with email and password", viewController: self)
        }
    }
    
    func validation() -> Bool {
        if self.txtEmail.text!.isEmpty {
            Alert().showAlert(message:"please provide email id", viewController: self)
            return false
        }
        if !isValidEmail(emailStr: self.txtEmail.text!){
            Alert().showAlert(message: "Please provie valied email id", viewController: self)
            return false
        }
        if txtPassword.text!.isEmpty {
            Alert().showAlert(message: "please provide password", viewController: self)
            return false
        }
        if txtPassword.text!.count < 5 {
            Alert().showAlert(message: "please provide minimum 6 digit password", viewController: self)
            return false
        }
        let userDefault = UserDefaults.standard
        if (userDefault.value(forKey: kPassword) != nil) {
            let password = userDefault.value(forKey: kPassword)
            if txtPassword.text != (password as! String) {
                Alert().showAlert(message: "please provide valied email or passsword.", viewController: self)
                return false
            }
        }
       
        return true
    }
}
extension ViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

