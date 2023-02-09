//
//  AddHospitalViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 12/02/21.
//

import UIKit


class AddHospitalViewController: UIViewController {

    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var viewbtnSubmit: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objAddHospital = AddHospitalViewModel()
    var isFromEditHospital:Bool = false
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    var objUserMedicalQuery = UserMedicalQuery()
    var updateData:updateDataWhenBackClosure?
    var objHospitalData = [String:Any]()
    var objUserMediclamDB = UserMediclamDB()
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfigureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        let isValidate = setVerification()
        if isValidate {
            if isFromEditHospital {
                self.updateInDatabase()
            } else {
                self.saveInDataBase()
            }
            backupDatabase(backupName: kPersonDataBase)
        }
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: "Are you sure you want to delete?", ok: { (success) in
            self.deleteFromDatabase()
        }, isCancel: false) { (failure) in
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func moveToAddBill() {
        let objProofDisplayViewController:ProofDisplayViewController = UIStoryboard(name: LoanDetials, bundle: nil).instantiateViewController(withIdentifier: "ProofDisplayViewController") as! ProofDisplayViewController
        objProofDisplayViewController.modalPresentationStyle = .overFullScreen
        objProofDisplayViewController.objProofDisplayViewModel.isSetUpBack = true
        objProofDisplayViewController.strMedicalid = "\(objAddHospital.medicalId)"
        self.present(objProofDisplayViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnGpayClicked(_ sender: Any) {
        if objAddHospital.arrDescription[7].isEmpty {
            Alert().showAlert(message:kAmountSelectOption, viewController: self)
            return
        }
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount =  objAddHospital.arrDescription[7]
        self.present(objSearchProduct, animated: true, completion: nil)
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
