//
//  SignUpViewController.swift
//  Economy
//
//  Created by devang bhavsar on 06/01/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var layOutConstriantImageWidth: NSLayoutConstraint!
    @IBOutlet weak var btnAgeCheck: UIButton!
    @IBOutlet weak var layoutConstraintyearHeight: NSLayoutConstraint!
    @IBOutlet weak var lblYearsMessage: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    @IBOutlet weak var imgBirthDown: UIImageView!
    @IBOutlet weak var lblnameSeprator: UILabel!
    @IBOutlet weak var lblSepratorBirthDay: UILabel!
    @IBOutlet weak var lblSepratorNumber: UILabel!
    @IBOutlet weak var imgDownGender: UIImageView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCornerSetUp: UIView!
    @IBOutlet weak var lblSepratorGender: UILabel!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewHeaderTbl: UIView!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtBirthDay: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblSepratorEmail: UILabel!
    @IBOutlet weak var lblSeparatorPassword: UILabel!
    @IBOutlet weak var lblSeparatorRePassword: UILabel!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var layoutConstraintPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintSubmitTop: NSLayoutConstraint!
    @IBOutlet weak var layOutConstriantTopTerms: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    var isFromSignUp:Bool = true
    @IBOutlet weak var txtRepassword: UITextField!
    @IBOutlet weak var layoutConstraintheightTerms: NSLayoutConstraint!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    var objSignUpViewModel = SignUpViewModel()
    var objFamilyMember = FamilyMemberQuery()
    var displayMemberData = [String:Any]()
    var updateData:updateDataWhenBackClosure?
    var objUserProfile = UserProfileDatabaseQuerySetUp()
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
          return formatter
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objSignUpViewModel.setHeaderView(headerView: viewHeader, isfromSignUp: isFromSignUp)
      //  objSignUpViewModel.isSignUp = isFromSignUp
        if !isFromSignUp {
            var objGetData = UserProfileDatabaseQuerySetUp()
            let userDefault = UserDefaults()
            let number = userDefault.value(forKey: kContactNumber)
            if number != nil {
                //let allData = objGetData.fetchData(contactNumber: number as! String)
                objGetData.fetchData() { (allData) in
                    if let name = allData["name"] {
                        self.txtName.text = (name as! String)
                    }
                    if let gender = allData["gender"] {
                        self.txtGender.text = (gender as! String)
                    }
                    if let emailId = allData["emailId"] {
                        self.txtEmail.text = (emailId as! String)
                    }
                    if let birthDay = allData["birthDay"] {
                        self.txtBirthDay.text = (birthDay as! String)
                    }
                    if let contactNumber = allData["contactNumber"] {
                        self.txtContactNumber.text = (contactNumber as! String)
                    }
                    if let password = allData["password"] {
                        self.txtPassword.text = (password as! String)
                    }
                } failure: { (isFailed) in
                }
            }
            
        }
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if isFromSignUp == false {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        viewCornerSetUp.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    @IBAction func btnBirthDayClicked(_ sender: Any) {
        self.setupPickerDate(viewController: self)
    }
    @IBAction func btnGenderClicked(_ sender: Any) {
        self.setUpPickerString(arrPickerData: ["Male","Female","Bigender","Other"], viewController: self)
    }
    @IBAction func btnTermsAndConditionClicked(_ sender: Any) {
        self.moveToTermsAndCondition()
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
      let isValied = self.validatation()
        if isValied {
            var dataStored:Bool = false
            var strMessage:String = "User Register"
            if isFromSignUp {
                 dataStored =  objUserProfile.saveinDataBase(name: txtName.text!, birthDay: txtBirthDay.text!, gender: txtGender.text!, contactNumber: txtContactNumber.text!, emailId: txtEmail.text!, password: txtPassword.text!)
                //let memberId = objFamilyMember.getLastId(record: (Int) -> Void)
                objFamilyMember.getLastId { (memberId) in
                    DispatchQueue.main.async {
                        if memberId <= 0 {
                            self.objFamilyMember.saveinDataBase(userid:"1",name: self.txtName.text!, occupation: "Business", relationShip:"Self", number: self.txtContactNumber.text!)
                        } else {
                            self.objFamilyMember.saveinDataBase(userid:"\(memberId)",name: self.txtName.text!, occupation: "Business", relationShip:"Self", number: self.txtContactNumber.text!)
                        }
                    }
     
                }
                let userDefault = UserDefaults()
                userDefault.setValue(txtContactNumber.text, forKey: kContactNumber)
                userDefault.setValue(txtEmail.text, forKey: kEmail)
                userDefault.setValue(txtPassword.text, forKey: kPassword)
                userDefault.synchronize()
                KeychainService.saveEmail(email: self.txtEmail.text! as NSString)
                KeychainService.savePassword(token: self.txtPassword.text! as NSString)
                backupDatabase(backupName: kPersonDataBase)
                if dataStored {
                    self.setUpAlertForDataSave(strMessage: strMessage)
                }
            } else {
                strMessage = "User Updated"
                setAlertWithCustomAction(viewController: self, message: "Are you sure you want to update new changes?", ok: { (isSuccess) in
                    self.objUserProfile.updateDataBase(name: self.txtName.text!, birthDay: self.txtBirthDay.text!, gender: self.txtGender.text!, contactNumber: self.txtContactNumber.text!, emailId: self.txtEmail.text!) { (isSuccess) in
                        self.setUpAlertForDataSave(strMessage: strMessage)
                    }
                }, isCancel: true) { (isfailed) in
                }
            }
           
        }
    }
    
    func setUpAlertForDataSave(strMessage:String)  {
        updateData!()
        setAlertWithCustomAction(viewController: self, message: strMessage, ok: { (isSuccess) in
            self.dismiss(animated: true, completion: nil)
        }, isCancel: false) { (isSuccess) in
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAgeCheckClicked(_ sender: Any) {
        let image = UIImage(named: "unChecked")
        let compare = imgCheckMark.image?.isEqualToImage(image: image!)
        if compare! {
            imgCheckMark.image = UIImage(named: "checked")
        } else {
            imgCheckMark.image = UIImage(named: "unChecked")
        }
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

