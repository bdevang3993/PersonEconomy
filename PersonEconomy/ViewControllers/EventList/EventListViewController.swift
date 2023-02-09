//
//  EventListViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/08/21.
//

import UIKit
import Floaty
class EventListViewController: UIViewController {

    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objLoanEntry = LoanEntry_PerMonthQuery()
    var objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
    var objMediclamData = UserMediclamDB()
    var arrLoanDetails = [[String:Any]]()
    var arrDisplayData = [[String:Any]]()
    var arrCombineData = [[String:Any]]()
    var arrSelectedData = [[String:Any]]()
    var arrMediclamData  = [[String:Any]]()
    var arrEventListData = [[String:Any]]()
    var arrReminderData = [[String:Any]]()
    var eventListViewModel = EventListViewModel()
    var objUserReminderQuery = UserReminderQuery()
    var floaty = Floaty()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
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
