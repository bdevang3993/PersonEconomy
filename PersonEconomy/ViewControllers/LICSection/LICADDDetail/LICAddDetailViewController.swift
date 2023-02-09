//
//  LICAddDetailViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit

class LICAddDetailViewController: UIViewController {
    @IBOutlet weak var viewBtnDisplay: UIView!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tblLICAdd: UITableView!
    var objLICAddDetails = LICAddDetailViewModel()
    var isFromEdit:Bool = false
    var dicLICdata = [String:Any]()
    var objAddLICDescription = UserLICDetailsQuery()
    var objAddLoanDetails = AddLoanDetailsViewModel()
    var objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
    var objUserLICDetailsQuery = UserLICDetailsQuery()
    var updateData:updateDataWhenBackClosure?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objLICAddDetails.setHeaderView(headerView: viewHeader, isFromEdit: isFromEdit)
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let isValied = self.setupValidation()
        var saveInDatabase:Bool = false
        if isValied {
            saveInDatabase = self.saveDataInDataBase()
        }
        if saveInDatabase {
            setAlertWithCustomAction(viewController: self, message: "Data save successfully", ok: { (success) in
                backupDatabase(backupName: kPersonDataBase)
                self.updateData!()
                self.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (failee) in
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
