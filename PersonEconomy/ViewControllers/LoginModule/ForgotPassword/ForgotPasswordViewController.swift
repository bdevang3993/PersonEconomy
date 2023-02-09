//
//  ForgotPasswordViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 17/03/21.
//

import UIKit
import MessageUI
class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var lblSepratorMobile: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var lblSepratorEmail: UILabel!
    var objForgotPassword = ForgotPasswordViewModel()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var objUserProfileDatabaseQuerySetUp = UserProfileDatabaseQuerySetUp()
    var arrSelectedData = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
   
    @IBAction func btnSubmitClicked(_ sender: Any) {
       
        let valiedDate = validation()
        if valiedDate {
            //let valiedNumber = getDataFromDB(number: txtMobileNumber.text!)
            getDataFromDB(number: txtMobileNumber.text!) { (isSuccess) in
                let userDefault = UserDefaults.standard
                if userDefault.value(forKey: kPassword) != nil && isSuccess {
                    let password = userDefault.value(forKey: kPassword)
                    self.setupForgotPasswordData(password: password as! String)
                } else {
                    let password = KeychainService.loadPassword()
                    let email = KeychainService.loadEmail()
                    if email == self.txtEmail.text && isSuccess{
                        self.setupForgotPasswordData(password: password)
                    } else {
                        Alert().showAlert(message: "Email or Mobile number does not match", viewController: self)
                    }
                }
            }
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
