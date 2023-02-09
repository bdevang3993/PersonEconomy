//
//  ExpenseViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 09/01/21.
//

import UIKit
import FSCalendar
import Floaty

typealias TAupdateDatabase = (Bool) -> Void
class ExpenseViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tblExpense: UITableView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewDate: FSCalendar!
    var isFromAddExpense:Bool = true
    var isReciptAttached:Bool = false
    var strSelectedDate:String = ""
    var taupdateDataBase:TAupdateDatabase?
    let objImagePickerViewModel = ImagePickerViewModel()
    @IBOutlet weak var btnSave: UIButton!
    var objExpenseViewModel = ExpenseViewModel()
    var objUserExpenseQuery = UserExpenseQuery()
    var objUserMemberList = FamilyMemberQuery()
    var allData = [String:Any]()
    var floaty = Floaty()
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var lblSelectedDate: UILabel!
    //MARK:- Calender View
     var currentPage: Date?
      private lazy var today: Date = {
          return Date()
      }()
    
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
     lazy var scopeGesture: UIPanGestureRecognizer = {
          [unowned self] in
          let panGesture = UIPanGestureRecognizer(target: self.viewDate, action: #selector(self.viewDate.handleScopeGesture(_:)))
          panGesture.delegate = self
          panGesture.minimumNumberOfTouches = 1
          panGesture.maximumNumberOfTouches = 2
          return panGesture
      }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getUserMemberList()
        self.setConfiguration()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    func getUserMemberList() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserMemberList.fetchData { (data) in
            if data.count > 0 {
                self.objExpenseViewModel.arrMemberName.removeAll()
                for i in 0...data.count - 1 {
                   let objName = data[i]
                    let name:String = objName["name"] as! String
                    self.objExpenseViewModel.arrMemberName.append(name)
                    self.tblExpense.reloadData()
                }
                MBProgressHub.dismissLoadingSpinner(self.view)
            } else {
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    let alertController = UIAlertController(title: kAppName, message: "please enter family member first", preferredStyle: .alert)
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.moveToFamilyMember()
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }


    }
    func setConfiguration() {
        self.layoutFAB()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewButton.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            viewButton.frame.size.height = (60.0 * (screenWidth/320.0))
        }
        viewButton.layoutIfNeeded()
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        var fontSize:CGFloat = 18.0
        var rowHeight:CGFloat = 40.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 28.0
            rowHeight = 60.0
        }
        self.viewDate.appearance.weekdayFont = UIFont.systemFont(ofSize: fontSize)
        self.viewDate.appearance.titleFont =  UIFont.systemFont(ofSize: fontSize - 4.0)
        self.viewDate.rowHeight = rowHeight
        self.viewDate.weekdayHeight = rowHeight
        if currentPage == nil {
            currentPage = Date()
        }
        self.viewDate.select(currentPage)
        objExpenseViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblSelectedDate.text = converFunction(date: currentPage!)
        lblSelectedDate.adjustsFontSizeToFitWidth = true
        lblSelectedDate.numberOfLines = 0
        lblSelectedDate.sizeToFit()
        strSelectedDate = lblSelectedDate.text!
        self.viewDate.scope = .week
        self.viewDate.dataSource = self
        self.viewDate.delegate = self
        objExpenseViewModel.setHeaderView(headerView: viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.viewDate.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        tblExpense.delegate = self
        tblExpense.dataSource = self
        if isFromAddExpense == false {
            btnDelete.isHidden = false
            self.viewDate.allowsSelection = false
            self.setvalueInTextField()
        }
        else {
            btnDelete.isHidden = true
            self.getTotalRecord()
        }
        btnSave.setUpButton()
    }
    
    func moveToFamilyMember() {
        let objMember:FamilyDetailsViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "FamilyDetailsViewController") as! FamilyDetailsViewController
        objMember.taUpdateMember = {[weak self] value in
            self?.getUserMemberList()
        }
        objMember.isFromDetails = false
        objMember.modalPresentationStyle = .overFullScreen
        self.present(objMember, animated: true, completion: nil)
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        if isFromAddExpense {
            moveCurrentPage(moveUp: false)
        }
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        if isFromAddExpense {
            moveCurrentPage(moveUp: true)
        }
    }
    func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = moveUp ? 1 : -1
        let currentDate = self.currentPage
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        let value = checkForNextDate(selectedDate: self.currentPage!)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert, viewController: self)
            self.currentPage = currentDate
            return
        }
        
        self.viewDate.setCurrentPage(self.currentPage!, animated: true)
        self.viewDate.select(self.currentPage)
        historySelectedDate = self.currentPage!
        objExpenseViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblSelectedDate.text = converFunction( date: self.currentPage!)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        
        if isFromAddExpense == true {
            self.saveDataInDataBase()
        } else {
            self.updateDataInDatabase()
        }
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: "Are you sure delete item?", ok: { (success) in
            self.deleteRecordFromDB()
        }, isCancel: true) { (faliue) in
        }
    }
    
    @IBAction func btnDateClicked(_ sender: Any) {
        if !isFromAddExpense {
            return
        }
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedDate) in
            DispatchQueue.main.async {
                self.lblSelectedDate.text = converFunction(date: selectedDate)
                self.objExpenseViewModel.strConvertedDate = convertdateFromDate(date: selectedDate)
                self.currentPage = selectedDate
                historySelectedDate = selectedDate
                self.viewDate.setCurrentPage(self.currentPage!, animated: true)
                self.viewDate.select(self.currentPage)
            }
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
