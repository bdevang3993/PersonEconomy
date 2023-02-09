//
//  AddBorrowViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 24/02/21.
//

import UIKit
import FSCalendar
class AddBorrowViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var viewBtnSave: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblBorrow: UITableView!
    var objAddBorrowViewModel = AddBorrowViewModel()
    var objUserAdvanceQuery = UserAdvanceQuery()
    var updatcallBack:updateDataWhenBackClosure?
    var dicBorrowData = [String:Any]()
    var isfromEdit:Bool = false
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    //MARK:- Calender View
    var currentPage: Date?
    lazy var today = {
        return Date()
    }
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
        self.setConfiguration()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPreviousClicked(_ sender: Any) {
        moveCurrentPage(moveUp: false)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        moveCurrentPage(moveUp: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        if validation() {
            if isfromEdit {
                self.updateInDatabase()
            } else {
                self.saveInDatabase()
            }
        }
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: "Are you sure you want to delete item?", ok: { (success) in
            self.deleteDataFromDB()
        }, isCancel: true) { (failed) in
        }
    }
    
    
    @IBAction func btnDateClicked(_ sender: Any) {
        if isfromEdit {
            return
        }
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedDate) in
            self.lblDate.text = converFunction(date: selectedDate)
            self.objAddBorrowViewModel.strConvertedDate = convertdateFromDate(date: selectedDate)
            self.currentPage = selectedDate
            historySelectedDate = selectedDate
            self.calenderView.setCurrentPage(self.currentPage!, animated: true)
            self.calenderView.select(self.currentPage)
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
