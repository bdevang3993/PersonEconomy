//
//  AddMedicalmViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 13/03/21.
//

import UIKit

class AddMedicalmViewController: UIViewController {
    
    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var viewbtnSubmit: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblAddData: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    var objAddMedicalmViewModel = AddMediclamViewModel()
    var objUserMediclamDB = UserMediclamDB()
    var updateData:updateDataWhenBackClosure?
    var isFromEdit:Bool = false
    var dicMediclamData = [String:Any]()
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if self.setValidation() {
            if isFromEdit {
                self.updateMediclamData()
            } else {
                self.saveMediclamData()
            }
            backupDatabase(backupName: kPersonDataBase)
        }
    }
    
    @IBAction func btnGpayClicked(_ sender: Any) {
        if objAddMedicalmViewModel.arrDescription[7].isEmpty {
            Alert().showAlert(message: kAmountSelectOption, viewController: self)
            return
        }
        
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount =  objAddMedicalmViewModel.arrDescription[7]
        self.present(objSearchProduct, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        self.deleteMediclamData()
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
