//
//  FamilyDetailsDisplayViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/01/21.
//

import UIKit

class FamilyDetailsDisplayViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Family Details"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(FamilyDetailsDisplayViewController(), action: #selector(FamilyDetailsDisplayViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}

extension FamilyDetailsDisplayViewController {
    func configData() {
        objFamilyDetails.setHeaderView(headerView: self.viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        self.getDetailsOfMember()
    }
    func getDetailsOfMember()  {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objgetFamilyQuery.fetchData { (result) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.arrAllFamilyData = result
            self.tblDisplayData.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    
}

extension FamilyDetailsDisplayViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        } else {
            return 70
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return arrAllFamilyData.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let allData = arrAllFamilyData[indexPath.row]
            if let name = allData["name"] {
                cell.lblItemDetails.text = (name as! String)
            }
            if let relationShip = allData["relationShip"] {
                cell.lblItemPrice.text = (relationShip as! String)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrAllFamilyData.count > 0 {
            let objFamilyDetails:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
            objFamilyDetails.isFromDetails = true
            objFamilyDetails.dicAllFamilyDetails = arrAllFamilyData[indexPath.row]
            objFamilyDetails.taUpdateMember = { [weak self] value in
                self?.getDetailsOfMember()
            }
            objFamilyDetails.modalPresentationStyle = .overFullScreen
            self.present(objFamilyDetails, animated: true, completion: nil)
        }
        
    }
    
    
}
