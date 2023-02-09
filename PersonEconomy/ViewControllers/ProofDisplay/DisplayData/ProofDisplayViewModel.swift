//
//  ProofDisplayViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/11/21.
//

import UIKit

class ProofDisplayViewModel: NSObject {
    var objuserData = UserDataQuery()
    var arrAllProof = [[String:Any]]()
    var headerViewXib:CommanView?
    var isSetUpBack:Bool = false
    var tblDisplay:UITableView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Proof Display"
        if isSetUpBack {
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib!.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(ProofDisplayViewController(), action: #selector(ProofDisplayViewController.backClicked), for: .touchUpInside)
            //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        }else {
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "drawer")
            headerViewXib!.lblBack.isHidden = true
            // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
            headerViewXib?.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(ProofDisplayViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        headerViewXib!.btnHeader.setTitle("Add", for: .normal)
        headerViewXib!.btnHeader.addTarget(ProofDisplayViewController(), action: #selector(ProofDisplayViewController.moveToNextViewController), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func getAllData(lblData:UILabel,view:UIView) {
        MBProgressHub.showLoadingSpinner(sender: view)
       // arrAllProof = objuserData.fetchData()
        objuserData.fetchData { (result) in
            self.arrAllProof = result
            if self.arrAllProof.count > 0 {
                lblData.isHidden = true
            } else {
                lblData.isHidden = false
            }
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(view)
                self.tblDisplay?.reloadData()
            }
        } failure: { (isFailed) in
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(view)
            }
        }
    }
    
    func  deleteAllEntry(userMedicalId:String,view:UIView, succes sucessData:@escaping((Bool) -> Void)) {
        MBProgressHub.showLoadingSpinner(sender: view)
        objuserData.deleteAllEntryFromDB(userMedicalId: userMedicalId) { (isSuccess) in
            if isSuccess {
                MBProgressHub.dismissLoadingSpinner(view)
                sucessData(true)
            } else {
                MBProgressHub.dismissLoadingSpinner(view)
                sucessData(false)
            }
        }
    }
    
    func deleteData(userid:Int,view:UIView,succes sucessData:@escaping((Bool) -> Void)) {
        MBProgressHub.showLoadingSpinner(sender: view)
        objuserData.deleteuserData(userDataId: userid) { (isSuccess) in
            if isSuccess{
                MBProgressHub.dismissLoadingSpinner(view)
                sucessData(true)
            }else {
                MBProgressHub.dismissLoadingSpinner(view)
                sucessData(false)
            }
        }
    }
}

extension ProofDisplayViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objProofDisplayViewModel.arrAllProof.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 350
        } else {
            return 250
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "ProofTableViewCell") as! ProofTableViewCell
        let data = objProofDisplayViewModel.arrAllProof[indexPath.row]
        cell.btnGpay.tag = indexPath.row
        if let name = data["name"] {
            cell.lblTitle.text = (name as! String)
        }
        if let date = data["endDate"] {
            cell.lblExpiredDate.text = (date as! String)
        }
        if let imageData = data["image"] {
            cell.imgDisplay.image = UIImage(data: imageData as! Data)
        }
        if let amount = data["price"] {
            cell.lblTotalAmount.text = "Total Amount : " + (amount as! String)
        }
        cell.selectedIndex = {[weak self] index in
            self?.gpayClicked(index: index)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = objProofDisplayViewModel.arrAllProof[indexPath.row]
        let objData:AddProofViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProofViewController") as! AddProofViewController
        objData.modalPresentationStyle = .overFullScreen
        objData.isfromEdit = true
        objData.struserMedicalId = strMedicalid
        objData.dicDataForEdit = data
        objData.updateData = {[weak self]  in
            self!.objProofDisplayViewModel.getAllData(lblData: self!.lblNoDataFound, view: (self?.view)!)
        }
        self.present(objData, animated: true, completion: nil)
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data =  objProofDisplayViewModel.arrAllProof[indexPath.row]
            objProofDisplayViewModel.deleteData(userid:data["userDataId"] as! Int, view: self.view) { (isSuccess) in
                self.objProofDisplayViewModel.arrAllProof.remove(at: indexPath.row)
                self.objProofDisplayViewModel.getAllData(lblData: self.lblNoDataFound, view: self.view)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
