//
//  SearchPayerDataViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import UIKit
import Floaty
class SearchPayerDataViewModel: NSObject {
    var objPayerDetailsQuery = PayerDetailsQuery()
    var arrAllPayer = [PayerData]()
    var arroldPayer = [PayerData]()
    var headerViewXib:CommanView?
    var viewController:UIViewController?
    var tableView:UITableView?
    var objPayerData = PayerData(strName: "", strURL: "", id: -1)
   
    func setHeaderView(headerView:UIView,isFromBack:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Sales Payment"
        headerViewXib!.btnBack.isHidden = false
        if isFromBack {
            headerViewXib!.btnBack.setImage(UIImage(named: "backArrow"), for: .normal)
            headerViewXib!.lblBack.isHidden = false
            headerViewXib!.btnBack.addTarget(SearchProductViewController(), action: #selector(SearchProductViewController.backClicked), for: .touchUpInside)
            
        }else {
            // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
            headerViewXib?.btnBack.setTitle("", for: .normal)
            headerViewXib!.lblBack.isHidden = true
            headerViewXib!.imgBack.image = UIImage(named: "drawer")
            headerViewXib?.btnBack.addTarget(SearchProductViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func fetchAllData(lblNoData:UILabel,view:UIView) {
        MBProgressHub.showLoadingSpinner(sender: view)
        objPayerDetailsQuery.fetchAllData { (result) in
            lblNoData.isHidden = true
            self.arroldPayer = result
            self.arrAllPayer = result
            self.tableView?.reloadData()
            MBProgressHub.dismissLoadingSpinner(view)
        } failure: { (isFailed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                lblNoData.isHidden = false
                MBProgressHub.dismissLoadingSpinner(view)
                self.arrAllPayer.removeAll()
                self.tableView?.reloadData()
            }
        }
    }    
    func filterSearchData(strName:String) {
        if strName.count > 1 {
            arrAllPayer = arroldPayer.filter{$0.strName.contains(strName)}
        } else {
            arrAllPayer = arroldPayer
        }
        self.tableView!.reloadData()
    }
    func moveToAddPayer(viewController:UIViewController,tblDisplayData:UITableView,lblNoData:UILabel,data:PayerData,strAmount:String,view:UIView) {
        let objPayer:AddPayerDetailViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "AddPayerDetailViewController") as! AddPayerDetailViewController
        if data.id == -1 {
            objPayer.isFromAddItem = true
        } else {
            objPayer.isFromAddItem = false
        }
        objPayer.objAddPayerDetailViewModel.objPayerData = data
        objPayer.strAmount = strAmount
        objPayer.modalPresentationStyle = .overFullScreen
        objPayer.updateAllData = {[weak self] in
            self?.fetchAllData(lblNoData: lblNoData, view:view)
        }
        viewController.present(objPayer, animated: true, completion: nil)
    }
    
    func deletePayerData(data:PayerData,deleted deletedData:@escaping((Bool) -> Void))  {
        let deleted = objPayerDetailsQuery.delete(id: data.id)
        if deleted {
            deletedData(true)
        } else {
            deletedData(false)
        }
    }
}
extension SearchProductViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  objPayerListViewModel.arrAllPayer.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "BusinessListTableViewCell") as! BusinessListTableViewCell
        let data:PayerData = objPayerListViewModel.arrAllPayer[indexPath.row]
            cell.lblTitle.text = data.strName
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let data:PayerData = objPayerListViewModel.arrAllPayer[indexPath.row]
        objPayerListViewModel.moveToAddPayer(viewController: self, tblDisplayData: self.tblDisplayData, lblNoData: lblNoData, data: data, strAmount: strDeductionAmount, view: self.view)
          
    }
    
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
            let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                success(true)
               MBProgressHub.showLoadingSpinner(sender: self.view)
                let data:PayerData = self.objPayerListViewModel.arrAllPayer[indexPath.row]
                self.objPayerListViewModel.deletePayerData(data: data) { (isSuccess) in
                    self.objPayerListViewModel.fetchAllData(lblNoData: self.lblNoData, view: self.view)
                    MBProgressHub.dismissLoadingSpinner(self.view)
                }
            })
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
     }
}
extension SearchProductViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
        
                    objPayerListViewModel.filterSearchData(strName: txtSearch.text!)
                return true
            }
        }
        if txtSearch.text!.count > 1 {
                let name:String = txtSearch.text! + string
                objPayerListViewModel.filterSearchData(strName: name.capitalizingFirstLetter())
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tblDisplayData!.reloadData()
        return true
    }
}
extension SearchProductViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add Payer Detail", icon: UIImage(named: "QRCode")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to add Item?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.objPayerListViewModel.moveToAddPayer(viewController: self, tblDisplayData: self.tblDisplayData, lblNoData: self.lblNoData, data: self.objPayerListViewModel.objPayerData, strAmount: self.strDeductionAmount, view: self.view)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        self.view.addSubview(floaty)
    }
}
