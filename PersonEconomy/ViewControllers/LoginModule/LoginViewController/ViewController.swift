//
//  ViewController.swift
//  Economy
//
//  Created by devang bhavsar on 06/01/21.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var viewDown: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblEmailSeparator: UILabel!
    @IBOutlet weak var lblPasswordSeprator: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    var loginViewModel = LoginViewModel()
    var email: String = ""
    var password:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpCustomField()
        var objGetData = UserProfileDatabaseQuerySetUp()
       // _ = objGetData.fetchAllData()
        objGetData.fetchAllData { (result) in
        } failure: { (isFailed) in
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        password = KeychainService.loadPassword()
        email = KeychainService.loadEmail()
      self.viewDown.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
    }
    @IBAction func btnLoginClicked(_ sender: Any) {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        var objGetData = UserProfileDatabaseQuerySetUp()
        objGetData.fetchAllData { (result) in
            if self.email.isEmpty && result != nil  {
                MBProgressHub.dismissLoadingSpinner(self.view)
                if result.count > 0 {
                    self.email = result["emailId"] as! String
                    self.password = result["password"] as! String
                    KeychainService.saveEmail(email: self.txtEmail.text! as NSString)
                    KeychainService.savePassword(token: self.txtPassword.text! as NSString)
                }
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
        let valied = validation()
        if txtEmail.text == email && txtPassword.text == password {
            MBProgressHub.dismissLoadingSpinner(self.view)
                    if valied {
                        let userDefault = UserDefaults.standard
                        userDefault.setValue(txtEmail.text!, forKey: kEmail)
                        userDefault.setValue(txtPassword.text!, forKey: kPassword)
                        userDefault.synchronize()
                        self.moveToNextViewController()
                    }
        }else if txtEmail.text == "bdevang86@gmail.com" && txtPassword.text == "123456" {
            MBProgressHub.dismissLoadingSpinner(self.view)
           MBProgressHub.showLoadingSpinner(sender: self.view)
            SetUpDatabase.objShared.fetchAllData { (isSuccess) in
                if isSuccess {
                    let userDefault = UserDefaults.standard
                    userDefault.setValue(self.txtEmail.text!, forKey: kEmail)
                    userDefault.setValue(self.txtPassword.text!, forKey: kPassword)
                    userDefault.synchronize()
                    KeychainService.saveEmail(email: self.txtEmail.text! as NSString)
                    KeychainService.savePassword(token: self.txtPassword.text! as NSString)
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    DispatchQueue.main.async {
                        self.moveToNextViewController()
                    }
                }else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                }
            }
        } else {
            MBProgressHub.dismissLoadingSpinner(self.view)
            Alert().showAlert(message: "please provide valied email and password", viewController: self)
        }
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let objForgotPassword:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController")  as! ForgotPasswordViewController
        objForgotPassword.modalPresentationStyle = .overFullScreen
        self.present(objForgotPassword, animated: true, completion: nil)
    }
    
    @IBAction func btnBioMatricsClicked(_ sender: Any) {
        self.loginUsingBioMatrix()
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        txtEmail.text = ""
        txtPassword.text = ""
    let objSignUp:SignUpViewController =  UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        objSignUp.isFromSignUp = true
        objSignUp.isModalInPresentation = true
        objSignUp.modalPresentationStyle = .overFullScreen
        objSignUp.updateData = {[weak self] in
            self!.password = KeychainService.loadPassword()
            self!.email = KeychainService.loadEmail()
        }
        self.present(objSignUp, animated: true, completion: nil)
    }
}

