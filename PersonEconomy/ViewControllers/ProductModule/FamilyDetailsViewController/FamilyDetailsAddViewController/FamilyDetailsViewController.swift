//
//  FamilyDetailsViewController.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
typealias TAisUpdatedMember = (Bool) -> Void
class FamilyDetailsViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtRelationShip: UITextField!
    @IBOutlet weak var btnRelationShip: UIButton!
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewHeaderTbl: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    var objFamilyDetailsViewModel = FamilyDetailsViewModel()
    var dicAllFamilyDetails = [String:Any]()
    var objFamilyMember = FamilyMemberQuery()
    var isFromDetails:Bool = false
    var taUpdateMember:TAisUpdatedMember?
    @IBOutlet weak var imgDownOccupation: UIImageView!
    
    @IBOutlet weak var lblSepratorName: UILabel!
    @IBOutlet weak var lblSepratorRelation: UILabel!
    @IBOutlet weak var lblSepratorOccupation: UILabel!
    @IBOutlet weak var lblSepratorNumber: UILabel!
    
    @IBOutlet weak var imgDown: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objFamilyDetailsViewModel.isFromEdit = isFromDetails
        self.getMemberfromDB()
        objFamilyDetailsViewModel.setHeaderView(headerView: viewHeader, isfromSignUp: false)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        let isvalied = self.validation()
        if isvalied {
            if isFromDetails {
                self.updateMemberInDB()
            }else {
                self.addMemberInDB()
            }
            backupDatabase(backupName: kPersonDataBase)
        }
    }
    @IBAction func btnRelationShipClicked(_ sender: Any) {
        self.setupPickerData()
    }
    
    @IBAction func btnOccupationClicked(_ sender: Any) {
        self.setupPickerForOccupationData()
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: "Are you sure  you want to delete member?", ok: { (success) in
            self.deletefromDataBase()
        }, isCancel:false) { (failed) in
            
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
