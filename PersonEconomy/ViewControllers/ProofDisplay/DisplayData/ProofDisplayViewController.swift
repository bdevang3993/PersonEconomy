//
//  ProofDisplayViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 30/10/21.
//

import UIKit

class ProofDisplayViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCornerRadious: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objProofDisplayViewModel = ProofDisplayViewModel()
    var strMedicalid:String = ""
    @IBOutlet weak var lblNoDataFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCornerRadious.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        objProofDisplayViewModel.getAllData(lblData: lblNoDataFound, view: self.view)
    }
    func configureData() {
        lblNoDataFound.textColor = hexStringToUIColor(hex: strTheamColor)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        objProofDisplayViewModel.setHeaderView(headerView: self.viewHeader)
        objProofDisplayViewModel.tblDisplay = self.tblDisplayData
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
       
    }
    func gpayClicked(index:Int) {
        var strPrice:String = "0"
        let data = objProofDisplayViewModel.arrAllProof[index]
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        if let price = data["price"] {
            strPrice = price as! String
        }
        objSearchProduct.strDeductionAmount = strPrice
        self.present(objSearchProduct, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteAllDataClicked(_ sender: Any) {
        if objProofDisplayViewModel.arrAllProof.count <= 0 {
            Alert().showAlert(message: "Don't have data to delete...", viewController: self)
            return
        }
        setAlertWithCustomAction(viewController: self, message: "Are you sure you want to delete all entry?", ok: {  (isSucess) in
            self.objProofDisplayViewModel.deleteAllEntry(userMedicalId: self.strMedicalid, view: self.view) { (isSucess) in
                if isSucess {
                    setAlertWithCustomAction(viewController: self, message: "Delete all data sucessfully", ok: { (isSucess) in
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isFailed) in
                    }
                }
            }
        }, isCancel: false) { (isfailed) in
        }
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func moveToNextViewController() {
        let objData:AddProofViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProofViewController") as! AddProofViewController
        objData.modalPresentationStyle = .overFullScreen
        objData.struserMedicalId = strMedicalid
        objData.updateData = {[weak self]  in
            self!.objProofDisplayViewModel.getAllData(lblData: self!.lblNoDataFound, view: (self?.view)!)
        }
        self.present(objData, animated: true, completion: nil)
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
