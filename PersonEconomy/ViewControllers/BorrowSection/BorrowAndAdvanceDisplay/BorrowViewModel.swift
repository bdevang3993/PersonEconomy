//
//  BorrowViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 23/02/21.
//

import UIKit
import FSCalendar
import Floaty
class BorrowViewModel: NSObject {
    var strConvertedDate:String = ""
    var arrBorrowDetail = [[String:Any]]()
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Account"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(BorrowViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension BorrowViewController: UITableViewDataSource,UITableViewDelegate {
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
        if section == 1 {
          return objBorrowViewModel.arrBorrowDetail.count
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblBorrowDisplay.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else  {
            let cell = tblBorrowDisplay.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let objData = objBorrowViewModel.arrBorrowDetail[indexPath.row]
            if let name = objData["name"] {
                cell.lblItemDetails.text = (name as! String)
            }
            if let type = objData["status"] {
                cell.lblItemType.text = (type as! String)
            }
            if let price = objData["price"] {
                cell.lblItemPrice.text = (price as! String)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let data = objBorrowViewModel.arrBorrowDetail[indexPath.row]
            let objEditData:AddBorrowViewController =  UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "AddBorrowViewController") as! AddBorrowViewController
            objEditData.isfromEdit = true
            objEditData.dicBorrowData = data
            objEditData.currentPage = currentPage
            objEditData.updatcallBack = {[weak self]  in
                DispatchQueue.main.async {
                    self?.fetchBorrowDetailFromDB(date: self!.currentPage!)
                }
            }
            objEditData.modalPresentationStyle = .overFullScreen
            self.present(objEditData, animated: true, completion: nil)
        }
     
    }
}
extension BorrowViewController : FSCalendarDataSource, FSCalendarDelegate {
    
      func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let value = checkForNextDate(selectedDate: date)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            return
        }
        _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        objBorrowViewModel.strConvertedDate = convertdateFromDate(date: date)
          lblDate.text = converFunction( date: date)
        self.currentPage = date
        historySelectedDate = date
        self.viewDate.setCurrentPage(self.currentPage!, animated: true)
        self.viewDate.select(self.currentPage)
        self.fetchBorrowDetailFromDB(date: self.currentPage!)
      }
      func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      }
}
extension BorrowViewController {
    
    func configureData() {
        objBorrowViewModel.setHeaderView(headerView: viewHeader)
        var fontSize:CGFloat = 18.0
        var rowHeight:CGFloat = 40.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 28.0
            rowHeight = 60.0
        }
        //self.calenderView.appearance.headerTitleFont = UIFont.systemFont(ofSize: fontSize)
        self.viewDate.appearance.weekdayFont = UIFont.systemFont(ofSize: fontSize)
        self.viewDate.appearance.titleFont =  UIFont.systemFont(ofSize: fontSize - 4.0)
        self.viewDate.rowHeight = rowHeight
        self.viewDate.weekdayHeight = rowHeight
        
        if currentPage == nil {
            currentPage = Date()
        }
        self.viewDate.select(currentPage)
        objBorrowViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction(date: currentPage!)
        lblDate.adjustsFontSizeToFitWidth = true
        lblDate.numberOfLines = 0
        lblDate.sizeToFit()
        self.fetchBorrowDetailFromDB(date: currentPage!)
        self.viewDate.scope = .week
        self.viewDate.dataSource = self
        self.viewDate.delegate = self
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewDate.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblBorrowDisplay.delegate = self
        self.tblBorrowDisplay.dataSource = self
        self.tblBorrowDisplay.tableFooterView = UIView()
    }
    
    
    func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = moveUp ? 1 : -1
        let currentDate = self.currentPage
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? today)
        let value = checkForNextDate(selectedDate: self.currentPage!)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            self.currentPage = currentDate
            return
        }
        self.viewDate.setCurrentPage(self.currentPage!, animated: true)
        self.viewDate.select(self.currentPage)
        historySelectedDate = self.currentPage!
        objBorrowViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction( date: self.currentPage!)
        self.fetchBorrowDetailFromDB(date: self.currentPage!)
    }
    
    func moveToAddBorrow() {
        let objAddBorrow:AddBorrowViewController = UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "AddBorrowViewController") as! AddBorrowViewController
        objAddBorrow.currentPage = currentPage
        objAddBorrow.updatcallBack = {[weak self]  in
            DispatchQueue.main.async {
                self?.fetchBorrowDetailFromDB(date: self!.currentPage!)
            }
        }
        objAddBorrow.modalPresentationStyle = .overFullScreen
        self.present(objAddBorrow, animated: true, completion: nil)
    }
    
    func moveToSearch() {
        let objSearchViewController:SearchExpnaceViewController = UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchExpnaceViewController") as! SearchExpnaceViewController
        objSearchViewController.modalPresentationStyle = .overFullScreen
        self.present(objSearchViewController, animated: true, completion: nil)
    }
    func fetchBorrowDetailFromDB(date:Date) {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserAdvanceModel.fetchDataUsingDate(date: dateFormatter.string(from: date)) { (result) in
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.objBorrowViewModel.arrBorrowDetail = result
            self.tblBorrowDisplay.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
}
extension BorrowViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add  Details", icon: UIImage(named: "expanse")) { item in
            DispatchQueue.main.async {
                setAlertWithCustomAction(viewController: self, message: "Are you sure you want to add  Details?", ok: { (value) in
                    self.moveToAddBorrow()
                }, isCancel: true) { (value) in
                    
                }
            }
        }
        self.view.addSubview(floaty)
    }
}
