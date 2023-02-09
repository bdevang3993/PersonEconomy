//
//  HomeViewController.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import Floaty
import FSCalendar

class HomeViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnDate: UIButton!
    var objUserProfileDB = UserProfileDatabaseQuerySetUp()
    var objExpenseAllData = [[String:Any]]()
    var floaty = Floaty()
    var datesWithMultipleEvents = [String]()
    @IBOutlet weak var viewHeader: UIView!
    let objHomeViewModel = HomeViewModel()
    var objUserExpense = UserExpenseQuery()
    var objLoanEntry = LoanEntry_PerMonthQuery()
    var objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
    var arrLoanDetails = [[String:Any]]()
    var arrDisplayData = [[String:Any]]()
    var totoalAmount:Int = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
          let panGesture = UIPanGestureRecognizer(target: self.calenderView, action: #selector(self.calenderView.handleScopeGesture(_:)))
          panGesture.delegate = self
          panGesture.minimumNumberOfTouches = 1
          panGesture.maximumNumberOfTouches = 2
          return panGesture
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let value = UserDefaults.standard.value(forKey: kiCloudeAlert) {
            if value as! Bool == false {
                Alert().showAlert(message: "if you want to take back up in icloude then please allow this app permission from the setting screen on toggle for save in icloude", viewController: self)
                UserDefaults.standard.setValue(true, forKey: kiCloudeAlert)
                UserDefaults.standard.synchronize()
            }
        }
        AppUpdaterMessage.getSingleton().showUpdateWithConfirmation()
        objHomeViewModel.setHeaderView(headerView: viewHeader)
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.tableFooterView = UIView()
        self.configureData()
        self.layoutFAB()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    func configureData() {
       
        if currentPage == nil {
            currentPage = Date()
        }
        var fontSize:CGFloat = 18.0
        var rowHeight:CGFloat = 40.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 28.0
            rowHeight = 60.0
        }
        self.calenderView.appearance.weekdayFont = UIFont.systemFont(ofSize: fontSize)
        self.calenderView.appearance.titleFont =  UIFont.systemFont(ofSize: fontSize - 4.0)
        self.calenderView.rowHeight = rowHeight
        self.calenderView.weekdayHeight = rowHeight
        self.calenderView.appearance.eventDefaultColor = .black
        //UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
        self.calenderView.select(currentPage)
        objHomeViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction(date: currentPage!)
        lblDate.adjustsFontSizeToFitWidth = true
        lblDate.numberOfLines = 0
        lblDate.sizeToFit()
        self.calenderView.scope = .week
        self.calenderView.dataSource = self
        self.calenderView.delegate = self
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.calenderView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.getAllDataFromDB()
        self.fetchAllDate()
        let userDefault = UserDefaults.standard
        let savedDate = userDefault.value(forKey: kDate)
        var isAllow:Bool = true
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        if savedDate != nil {
            let newDate = dateFormatter.string(from: savedDate as! Date)
            let convertSavedDate:Date = dateFormatter.date(from: newDate)!
            let diffInDays:Int = Calendar.current.dateComponents([.day], from: convertSavedDate, to:curentDate).day!
            if diffInDays <= 0 {
                isAllow = false
            } else {
                isAllow = true
            }
        }
        if appDelegate.isFirstTime && isAllow {
            self.fetchAllEvents()
        }
    }
    
    func getAllDataFromDB() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        objUserExpense.fetchData(date: lblDate.text!) { (result) in
            self.objExpenseAllData = result
            self.tblDisplayData.reloadData()
            self.updateTotalData()
            MBProgressHub.dismissLoadingSpinner(self.view)
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        moveCurrentPage(moveUp: false)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        moveCurrentPage(moveUp: true)
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
        
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
        historySelectedDate = self.currentPage!
        objHomeViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction( date: self.currentPage!)
        self.getAllDataFromDB()
    }
    
    func updateTotalData() {
        totoalAmount = 0
        if objExpenseAllData.count > 0 {
            for i in 0...objExpenseAllData.count - 1 {
                let data = objExpenseAllData[i]
                var value:String = data["price"] as! String
                if value.isEmpty {
                    value = "0"
                }
                totoalAmount = totoalAmount + Int(value)!
            }
        }
        self.tblDisplayData.reloadData()
    }
    
    @IBAction func btnDateClicked(_ sender: Any) {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedDate) in
            self.lblDate.text = converFunction(date: selectedDate)
            self.objHomeViewModel.strConvertedDate = convertdateFromDate(date: selectedDate)
            self.currentPage = selectedDate
             historySelectedDate = selectedDate
            self.calenderView.setCurrentPage(self.currentPage!, animated: true)
            self.calenderView.select(self.currentPage)
            self.getAllDataFromDB()
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
