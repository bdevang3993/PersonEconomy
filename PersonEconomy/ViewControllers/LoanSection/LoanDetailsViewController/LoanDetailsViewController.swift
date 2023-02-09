//
//  LoanDetailsViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 06/02/21.
//

import UIKit

class LoanDetailsViewController: UIViewController {

    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDetails: UITableView!
    let objloanDetailsViewModel = LoanDetailsViewModel()
    var objLoanDetails = UserLoanDetailsQuery()
    var objLoanEntryPerMonth = LoanEntry_PerMonthQuery()
    var updatedata:updateDataWhenBackClosure?
    var arrLoanDetails = [[String:Any]]()
    var strLoanId:String = ""
    var strBankName:String = ""
    var totalAmount:Int = 0
    
    @IBOutlet weak var btnDelete: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objloanDetailsViewModel.setHeaderView(headerView: viewHeader)
        self.fetchDataFromDataBase()
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }

    @IBAction func btnDeleteClicked(_ sender: Any) {
        self.delteAllData()
    }
    @objc func backCliked() {
        self.dismiss(animated: true, completion:nil)
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
