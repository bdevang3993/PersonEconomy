//
//  MediclamDisplayViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 13/03/21.
//

import UIKit

class MediclamDisplayViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrAllMedicalmData = [[String:Any]]()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Display Mediclam"
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(MedicalmDisplayViewController(), action: #selector(MedicalmDisplayViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension MedicalmDisplayViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return objmediclamDisplayViewModel.arrAllMedicalmData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblMediclamDisplay.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            return cell
        }else {
            let cell = tblMediclamDisplay.dequeueReusableCell(withIdentifier: "HospitalDataTableViewCell") as! HospitalDataTableViewCell
            let objMediclamlData = objmediclamDisplayViewModel.arrAllMedicalmData[indexPath.row]
            if let memberName = objMediclamlData["memberName"] {
                cell.lblName.text =  (memberName as! String)
            }
            if let hospitalName = objMediclamlData["type"] {
                cell.lblHospitalName.text =  (hospitalName as! String)
            }
            if let amount = objMediclamlData["amount"] {
                cell.lblPrice.text =  (amount as! String)
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objHospitalData = objmediclamDisplayViewModel.arrAllMedicalmData[indexPath.row]
        let objMediclamViewController:AddMedicalmViewController = UIStoryboard(name: Medical, bundle: nil).instantiateViewController(identifier: "AddMedicalmViewController") as! AddMedicalmViewController
        objMediclamViewController.modalPresentationStyle = .overFullScreen
        objMediclamViewController.updateData = { [weak self] in
            self!.getAllMember()
        }
        objMediclamViewController.isFromEdit = true
        objMediclamViewController.dicMediclamData = objHospitalData
        self.present(objMediclamViewController, animated: true, completion: nil)
    }
}
extension MedicalmDisplayViewController {
    func configData() {
        self.getAllMember()
        objmediclamDisplayViewModel.setHeaderView(headerView: self.viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblMediclamDisplay.delegate = self
        self.tblMediclamDisplay.dataSource = self
        self.tblMediclamDisplay.tableFooterView = UIView()
    }
}
//MARK:- Database Query
extension MedicalmDisplayViewController {
    func getAllMember() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        DispatchQueue.main.async {
            self.objUserMediclamDB.fetchMedicalmData { (result) in
                self.objmediclamDisplayViewModel.arrAllMedicalmData = result
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.tblMediclamDisplay.reloadData()
            } failure: { (isFailed) in
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
}
