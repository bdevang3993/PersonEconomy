//
//  SearchViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/03/21.
//

import UIKit
import Floaty
import CoreData
import IQKeyboardManagerSwift
import Screenshots

class SearchExpnaceModel: NSObject {
    var headerViewXib:CommanView?
    var arrBorrowDetail = [[String:Any]]()
    var arrMemberName = [String]()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Search Account"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(SearchExpnaceViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
}
extension SearchExpnaceViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section ==  0 {
                return 90
            } else if indexPath.section == 1 {
                return 80
            } else {
                return 100
            }
        } else {
            if indexPath.section ==  0 {
                return 60
            } else if indexPath.section == 1 {
                return 50
            } else {
                return 70
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return objSearchExpenseViewModel.arrBorrowDetail.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.transform = CGAffineTransform(rotationAngle: 360)
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                cell.transform = CGAffineTransform(rotationAngle: 0.0)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblSearchData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tblSearchData.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            let objData = objSearchExpenseViewModel.arrBorrowDetail[indexPath.row]
            if let date = objData["date"] {
                cell.lblDateofPay.text = (date as! String)
            }
            if let item = objData["item"] {
                cell.lblBankName.text = (item as! String)
            }
            if let price = objData["price"] {
                cell.lblDeduction.text = (price as! String)
            }

            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblSearchData.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = "\(totoalAmount.rounded(toPlaces: 2))"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let data = objSearchExpenseViewModel.arrBorrowDetail[indexPath.row]
            let objEditData:AddBorrowViewController =  UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "AddBorrowViewController") as! AddBorrowViewController
            objEditData.isfromEdit = true
            objEditData.dicBorrowData = data
            let strDate = data["date"] as! String
            objEditData.currentPage = dateFormatter.date(from: strDate)
            objEditData.updatcallBack = {[weak self]  in
                self!.fetchSearchData(name: self!.txtName.text!)
            }
            objEditData.modalPresentationStyle = .overFullScreen
            self.present(objEditData, animated: true, completion: nil)
        }
    }
}
extension SearchExpnaceViewController {
    func configData() {
        self.lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
        self.txtName.textColor = hexStringToUIColor(hex: strTheamColor)
        self.txtType.textColor = hexStringToUIColor(hex: strTheamColor)
        self.lblNoData.isHidden = false
        self.tblSearchData.isHidden = true
        objSearchExpenseViewModel.setHeaderView(headerView: self.viewHeader)
        imgDownName.tintColor = hexStringToUIColor(hex: strTheamColor)
        imgDownType.tintColor = hexStringToUIColor(hex: strTheamColor)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.txtName.layer.borderWidth = 1.0
        self.txtName.layer.borderColor = UIColor.white.cgColor
        self.txtType.layer.borderWidth = 1.0
        self.txtType.layer.borderColor = UIColor.white.cgColor
        txtType.layer.borderColor = UIColor.white.cgColor
        self.tblSearchData.delegate = self
        self.tblSearchData.dataSource = self
        self.tblSearchData.tableFooterView = UIView()
        self.layoutFAB()
    }
    
    func deleteAllEntry() {
        let isEntryDeleted = objUserAdvanceModel.deleteAllEntry { (isSuccess) in
            self.txtType.text = ""
            self.fetchSearchData(name: self.txtName.text!)
        }
    }
    func setAlertForDatePicker() {
        setAlertWithCustomAction(viewController: self, message: "please choose the date of paied", ok: { (success) in
            self.setDate()
        }, isCancel: false) { (falied) in
        }
    }
    func moveToPayment() {
        let objPayment:PaySomeAmountViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "PaySomeAmountViewController") as! PaySomeAmountViewController
        objPayment.modalPresentationStyle = .overFullScreen
        objPayment.totalAmount = totoalAmount
        objPayment.arrBorrowDetail = objSearchExpenseViewModel.arrBorrowDetail
        objPayment.updateAllData = {[weak self] in
            self!.fetchDataWithType(name: self!.txtName.text!, type: self!.txtType.text!)
        }
        self.present(objPayment, animated: true, completion: nil)
    }
    func setDate() {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedValue) in
            let strSelectedDate = self.dateFormatter.string(from: selectedValue)
            DispatchQueue.main.async {
                MBProgressHub.showLoadingSpinner(sender: self.view)
                for i in 0...self.objSearchExpenseViewModel.arrBorrowDetail.count - 1 {
                    let data = self.objSearchExpenseViewModel.arrBorrowDetail[i]
                    let id = data["advanceId"] as! String
                    _ = self.objUserAdvanceModel.updateuserAdvanceDetails(date: data["date"] as! String, item: data["item"] as! String, name: data["name"] as! String, paidDate: strSelectedDate, price: data["price"] as! String, status: "Paied", transactionId: data["transactionId"] as! String, advanceId: id, userExpenseId: "", succees: { (isSuccess) in
                        MBProgressHub.dismissLoadingSpinner(self.view)
                        self.txtType.text = ""
                        self.fetchSearchData(name: self.txtName.text!)
                        self.openPaymentGateway()
                    })
                }
               
            }
        }
    }
    func openPaymentGateway() {
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount = "\(totoalAmount)"
        self.present(objSearchProduct, animated: true, completion: nil)
    }
    
    func fetchSearchData(name:String) {
        MBProgressHub.showLoadingSpinner(sender: self.view)
          objUserAdvanceModel.fetchDataUsingName(name: name, record: { (result) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.objSearchExpenseViewModel.arrBorrowDetail = result
            self.updateTotalData()
            self.tblSearchData.reloadData()
        }, failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        })
    }
    func fetchDataWithType(name:String,type:String) {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserAdvanceModel.fetchDataUsingNameAndStatus(name: name, status: type) { (result) in
            self.objSearchExpenseViewModel.arrBorrowDetail = result
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.updateTotalData()
            self.tblSearchData.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func updateTotalData() {
        totoalAmount = 0
        if objSearchExpenseViewModel.arrBorrowDetail.count > 0 {
            self.lblNoData.isHidden = true
            self.tblSearchData.isHidden = false
            for i in 0...objSearchExpenseViewModel.arrBorrowDetail.count - 1 {
                let data = objSearchExpenseViewModel.arrBorrowDetail[i]
                var value:String = data["price"] as! String
                if value.isEmpty {
                    value = "0"
                }
                totoalAmount = totoalAmount + Double(value)!
            }
        }
        self.tblSearchData.reloadData()
    }
    func screenshot() -> UIImage{
        
        
        let datedisplay:UIView = UIView(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 80))
        let lblDate:UILabel = UILabel(frame: CGRect(x: 0, y: 5, width: screenWidth, height: 25))
        lblDate.font = .boldSystemFont(ofSize: 20.0)
        
        let viewdeshLine2:UIView = UIView(frame: CGRect(x: 0, y:15, width: screenWidth, height: 20))
        drawDottedLine(start: CGPoint(x: viewdeshLine2.bounds.minX, y: viewdeshLine2.bounds.minY), end: CGPoint(x: viewdeshLine2.bounds.maxX, y: viewdeshLine2.bounds.minY), view: viewdeshLine2)
      
        
        let viewdeshLine3:UIView = UIView(frame: CGRect(x: 0, y:40, width: screenWidth, height: 20))
        drawDottedLine(start: CGPoint(x: viewdeshLine3.bounds.minX, y: viewdeshLine3.bounds.minY), end: CGPoint(x: viewdeshLine3.bounds.maxX, y: viewdeshLine3.bounds.minY), view: viewdeshLine3)
       
        
        let lblNumber:UILabel = UILabel(frame: CGRect(x: 0, y: 40, width: screenWidth - 60, height: 30))
     
        lblNumber.font = .systemFont(ofSize: 14.0)
        let userDefualt = UserDefaults.standard
        if let name = userDefualt.value(forKey: kCompanyName) {
            lblDate.text = (name as! String).capitalized
            lblDate.text = lblDate.text?.capitalized
        }
        lblDate.textAlignment = .center
        datedisplay.addSubview(lblDate)
        if let number = userDefualt.value(forKey: kContactNumber) {
            lblNumber.text = (number as! String)
        }
        lblNumber.textAlignment = .right
        datedisplay.addSubview(lblNumber)
        
        
        
        var imageLogo:UIImage?
        if let imageName = userDefualt.value(forKey: kLogo){
            imageLogo = getSavedImage(named: imageName as! String)
        }
        let uiimageView:UIImageView = UIImageView(frame: CGRect(x: 30, y: 100, width: screenWidth - 60, height: 100))
        uiimageView.contentMode = .scaleToFill
        uiimageView.image = imageLogo
       
        
        let lblCustomerName:UILabel = UILabel(frame: CGRect(x: 0, y: 230, width: screenWidth, height: 30))//80
        lblCustomerName.text = txtName.text
        lblCustomerName.font = .boldSystemFont(ofSize: 14.0)
        lblCustomerName.textAlignment = .center
       
        
        let tempView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:  datedisplay.frame.size.height + 140))
        tempView.backgroundColor = .white
        tempView.addSubview(viewdeshLine2)
        tempView.addSubview(datedisplay)
        tempView.addSubview(viewdeshLine3)
        tempView.addSubview(uiimageView)
        tempView.addSubview(lblCustomerName)
        
        
        let tempImage = tempView.screenshot
        let tableViewScreenShot:UIImage = self.tblSearchData.screenshot!
        let newImageWithTableView = tempImage?.mergeImage(image2: tableViewScreenShot)

        var newImageWithQRCode:UIImage = UIImage()
        var isQRcode:Bool = false
        var imageQRCode:UIImage?
        if let imageName = userDefualt.value(forKey: kQRCode){
            imageQRCode = getSavedImage(named: imageName as! String)
        }
        if imageQRCode != nil {
            isQRcode = true
            newImageWithQRCode = (newImageWithTableView?.mergeImage(image2: imageQRCode!))!
        }

        let viewdeshLine:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblSearchData.contentSize.width, height: 20))
        drawDottedLine(start: CGPoint(x: viewdeshLine.bounds.minX, y: viewdeshLine.bounds.minY), end: CGPoint(x: viewdeshLine.bounds.maxX, y: viewdeshLine.bounds.minY), view: viewdeshLine)

        let lblThanks:UILabel = UILabel(frame: CGRect(x: 0, y: 20, width: screenWidth, height: 40))
        lblThanks.font = .boldSystemFont(ofSize: 10.0)
        lblThanks.numberOfLines = 0
        lblThanks.text = "Thank you for the privilege of your business, If you have any query then please visit us, if you want to pay using payment gatway then plase user above qr code or given company number"
        lblThanks.textAlignment = .center

        let viewdeshLine1:UIView = UIView(frame: CGRect(x: 0, y:80, width: screenWidth, height: 20))
        drawDottedLine(start: CGPoint(x: viewdeshLine1.bounds.minX, y: viewdeshLine1.bounds.minY), end: CGPoint(x: viewdeshLine1.bounds.maxX, y: viewdeshLine1.bounds.minY), view: viewdeshLine1)

        
        let bottomView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120))
        bottomView.backgroundColor = .white
        bottomView.addSubview(viewdeshLine)
        bottomView.addSubview(lblThanks)
        bottomView.addSubview(viewdeshLine1)
        
        let bottomImage = bottomView.screenshot
        var lastImage:UIImage?
        
        if isQRcode == true {
            lastImage = newImageWithQRCode.mergeImage(image2: bottomImage!)
        } else {
            lastImage = newImageWithTableView?.mergeImage(image2: bottomImage!)
        }
       
        return lastImage!
    }
    func shareImage(image:UIImage) {

        let imageShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
     }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    func moveToIcon() {
        let objLogoAndNameViewController:LogoAndNameViewController = UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "LogoAndNameViewController") as! LogoAndNameViewController
        objLogoAndNameViewController.modalPresentationStyle = .overFullScreen
        self.present(objLogoAndNameViewController, animated: true, completion: nil)
    }
    func getNameList() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        AllMemberList.shared.getMemberList { (result) in
            self.objSearchExpenseViewModel.arrMemberName = AllMemberList.shared.getNameArray()
        }
        MBProgressHub.dismissLoadingSpinner(self.view)
    }
    func pickData() {
        txtType.text?.removeAll()
        if objSearchExpenseViewModel.arrMemberName.count <= 0 {
            Alert().showAlert(message: "please add customer type member from home screen and add details", viewController: self)
            return
        } else {
            IQKeyboardManager.shared.resignFirstResponder()
            PickerView.objShared.setUPickerWithValue(arrData: objSearchExpenseViewModel.arrMemberName, viewController: self) { (selectedValue) in
                DispatchQueue.main.async {
                    self.txtName.text = selectedValue
                }
                self.fetchSearchData(name: (selectedValue))
            }
        }
    }
}

extension SearchExpnaceViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Share  Details", icon: UIImage(named: "share")) { item in
            DispatchQueue.main.async {
                let userDefault = UserDefaults.standard
                if userDefault.value(forKey: kCompanyName) == nil {
                    Alert().showAlert(message: "please add Business Detail First", viewController: self)
                    return
                } else {
                    let name = userDefault.value(forKey: kCompanyName) as! String
                    if name.count <= 0 {
                        Alert().showAlert(message: "please add Business Detail First", viewController: self)
                        return
                    }
                }
                setAlertWithCustomAction(viewController: self, message: "Are you sure you want to Share  Details?", ok: { (value) in
                    let image = self.screenshot()
                    self.shareImage(image: image)
                }, isCancel: true) { (value) in
                    
                }
            }
        }
        floaty.addItem("Delete all Paied Entries", icon: UIImage(systemName:"trash")) { item in
            DispatchQueue.main.async {
                if self.txtType.text == "Paied" {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure delete all Paied Entries?", ok: { (value) in
                        self.deleteAllEntry()
                    }, isCancel: true) { (value) in
                        
                    }
                } else {
                    Alert().showAlert(message: "please select type as Paied", viewController: self)
                }
             
            }
        }
        
        
        floaty.addItem("Paid All dues", icon: UIImage(named: "dues")) { item in
            DispatchQueue.main.async {
                if self.txtType.text == "Borrow" {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure paied all dues?", ok: { (value) in
                        self.setAlertForDatePicker()
                    }, isCancel: true) { (value) in
                        
                    }
                } else {
                    Alert().showAlert(message: "please select type as Borrow", viewController: self)
                }
             
            }
        }
        floaty.addItem("Paid Some dues", icon: UIImage(named: "dues")) { item in
            DispatchQueue.main.async {
                if self.txtType.text == "Borrow" && self.totoalAmount > 500 {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure paied some dues more then 500?", ok: { (value) in
                        self.moveToPayment()
                    }, isCancel: true) { (value) in
                        
                    }
                } else if self.totoalAmount < 500 {
                    Alert().showAlert(message: "If dues amount should be more then 500 then only you give some installment", viewController: self)
                }
                else {
                    Alert().showAlert(message: "please select type as Borrow", viewController: self)
                }
             
            }
        }
        floaty.addItem("Add Business Detail", icon: UIImage(named: "business")) { item in
            DispatchQueue.main.async {
                setAlertWithCustomAction(viewController: self, message: "Are you sure you want to add  icon?", ok: { (value) in
                    self.moveToIcon()
                }, isCancel: true) { (value) in
                    
                }
            }
        }
        self.view.addSubview(floaty)
    }
}
