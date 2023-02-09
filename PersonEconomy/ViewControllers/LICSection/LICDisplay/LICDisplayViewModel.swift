//
//  LICDisplayViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit
import Floaty

enum SelectedOption {
   case None
   case Edit
   case Detail
   case Delete
}
class LICDisplayViewModel: NSObject {
    var arrTitle = ["PolicyNumber","Member Name","Deduction Amount","StartDate","Total Months","Contact Person","Contact Number"]
    var selectedOption = SelectedOption.None
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "LIC Section"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LICDisplayViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    var arrDescription = [String]()
    var arrTotalMonth = [String]()
    var selectedDate:String = ""
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
          return formatter
      }()
    private lazy var today: Date = {
             return Date()
         }()
    func setupDescription() {
        arrDescription.removeAll()
        for _ in 0...arrTitle.count - 1 {
            arrDescription.append("")
        }
    }
}
extension LICDisplayViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return arrLICData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblLICDisplay.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblLICDisplay.dequeueReusableCell(withIdentifier: "LICDisplayTableViewCell") as! LICDisplayTableViewCell
            let allData = arrLICData[indexPath.row]
            if let name = allData["name"] {
                cell.lblName.text = (name as! String)
            }
            if let date = allData["date"] {
                cell.lblDate.text = (date as! String)
            }
            cell.lblAmount.text = "\(self.totalAmount(dicData: allData))"//(price as! String)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch objLICDisplayViewModel.selectedOption {
        case .None:
            self.moveToDetail(index: indexPath.row)
            objLICDisplayViewModel.selectedOption = .None
            break
        case .Edit: self.moveToEditData(index: indexPath.row)
            objLICDisplayViewModel.selectedOption = .None
            break
        case .Detail: self.moveToDetail(index: indexPath.row)
            objLICDisplayViewModel.selectedOption = .None
            break
        default:
            Alert().showAlert(message: "Please select one option from + button", viewController: self)
        }
    }
    
}
extension LICDisplayViewController {
    func moveToEditData(index:Int) {
        let objAddLICData:LICAddDetailViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LICAddDetailViewController") as! LICAddDetailViewController
        objAddLICData.modalPresentationStyle = .overFullScreen
        objAddLICData.isFromEdit = true
        objAddLICData.dicLICdata = arrLICData[index]
        objAddLICData.updateData = {[weak self] in
            self!.fetchAllDataFromDatabase()
        }
        self.present(objAddLICData, animated: true, completion: nil)
    }
    func moveToDetail(index:Int) {
        let objLICDetails:LICDetailViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LICDetailViewController") as! LICDetailViewController
        objLICDetails.modalPresentationStyle = .overFullScreen
        let objData = arrLICData[index]
        objLICDetails.strpolicyNumber = objData["policyNumber"] as! String
        objLICDetails.csUpdateData = {[weak self] in
            self!.fetchAllDataFromDatabase()
        }
        self.present(objLICDetails, animated: true, completion: nil)
    }

    func configureData() {
        self.fetchAllDataFromDatabase()
        objLICDisplayViewModel.setupDescription()
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblLICDisplay.delegate = self
        self.tblLICDisplay.dataSource = self
        self.tblLICDisplay.tableFooterView = UIView()
        self.layoutFAB()
    }
    func moveToLICAdd() {
        let objAddDetails:LICAddDetailViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "LICAddDetailViewController") as! LICAddDetailViewController
        objAddDetails.modalPresentationStyle = .overFullScreen
        objAddDetails.updateData = {[weak self] in
            DispatchQueue.main.async {
                self?.fetchAllDataFromDatabase()
            }
        }
        self.present(objAddDetails, animated: true, completion: nil)
    }
    
    func fetchAllDataFromDatabase()  {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserLICDetailsQuery.fetchData { (result) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.arrLICData = result
            self.tblLICDisplay.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func totalAmount(dicData:[String:Any]) -> Int {
        var totalPrice:Int = 0
        var totalMonths:Int = 0
        var multiplayer:Int = 1
        if let type = dicData["type"] {
            let selectedType = type as! String
            switch selectedType {
            case "Quarterly":
                multiplayer = 4
                break
            case "Half Year":
                multiplayer = 2
                break
            default:
                multiplayer = 1
            }
        }
        if let months = dicData["months"] {
            totalMonths = Int(months as! String)!
        }
        if let price = dicData["amount"] {
            totalPrice = totalMonths * multiplayer * Int(price as! String)!
        }
        return totalPrice
    }
}
extension LICDisplayViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add LIC Details", icon: UIImage(named: "lic")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to add LIC Details?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                    self.moveToLICAdd()
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
        self.setdidSelectOption()
    }
    
    func setdidSelectOption()  {
        
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        floaty.addItem("LIC Details", icon: UIImage(named: "lic")) { item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want to Edit LIC Details please select entry?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    // NSLog("OK Pressed")
                    DispatchQueue.main.async {
                        self.objLICDisplayViewModel.selectedOption = SelectedOption.Edit
                        //self.moveToEditData(index: index)
                    }
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
        
       
        //floaty1.addItem(item: item)
       // floaty1.paddingX = self.view.frame.width/2 - floaty.frame.width/2
       
        self.view.addSubview(floaty)
    }
}
