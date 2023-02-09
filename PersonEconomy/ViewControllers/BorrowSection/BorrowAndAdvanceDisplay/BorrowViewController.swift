//
//  BorrowViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 23/02/21.
//

import UIKit
import FSCalendar
import Floaty
class BorrowViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewDate: FSCalendar!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnNextDate: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var tblBorrowDisplay: UITableView!
    @IBOutlet weak var viewBackground: UIView!
    var objBorrowViewModel = BorrowViewModel()
    var objUserAdvanceModel = UserAdvanceQuery()
    var floaty = Floaty()
    @IBOutlet weak var btnDate: UIButton!
    
    //MARK:- Calender View
     var currentPage: Date?
    lazy var today: Date = {
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
        self.configureData()
        self.layoutFAB()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        moveCurrentPage(moveUp: false)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        moveCurrentPage(moveUp: true)
    }
    
    @IBAction func btnDateClicked(_ sender: Any) {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedDate) in
            DispatchQueue.main.async {
                self.lblDate.text = converFunction(date: selectedDate)
                self.objBorrowViewModel.strConvertedDate = convertdateFromDate(date: selectedDate)
                self.lblDate.text = converFunction( date: selectedDate)
                self.currentPage = selectedDate
                historySelectedDate = selectedDate
                self.viewDate.setCurrentPage(self.currentPage!, animated: true)
                self.viewDate.select(self.currentPage)
                self.fetchBorrowDetailFromDB(date: self.currentPage!)
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
