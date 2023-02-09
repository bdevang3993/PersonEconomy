//
//  CommonSearchViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 06/03/21.
//

import UIKit

class CommonSearchViewController: UIViewController {

    @IBOutlet weak var imgDown: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    var objCommonSearchViewModel = CommonSearchViewModel()
    var objLoanDetails = UserLoanDetailsQuery()
    var objUserMedicalQuery = UserMedicalQuery()
    var objUserLICDetailsQuery = UserLICDetailsQuery()
    var objUserExpense = UserExpenseQuery()
    var objUserMediclame = UserMediclamDB()
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
    override func viewDidDisappear(_ animated: Bool) {
        backupDatabase(backupName: kPersonDataBase)
    }
    @IBAction func btnNameClicked(_ sender: Any) {
        self.memberName()
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
