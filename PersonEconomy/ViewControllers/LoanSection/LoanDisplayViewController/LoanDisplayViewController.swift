//
//  LoanDisplayViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 12/01/21.
//

import UIKit
import Floaty
class LoanDisplayViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCornerDisplay: UIView!
    @IBOutlet weak var tblDisplayLoan: UITableView!
    let objLoanDisplayViewModel = LoanDIsplayViewModel()
    var objLoanDetails = UserLoanDetailsQuery()
   
    var floaty = Floaty()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfiguration()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCornerDisplay.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    func setConfiguration() {
        tblDisplayLoan.delegate = self
        tblDisplayLoan.dataSource = self
        tblDisplayLoan.tableFooterView = UIView()
        self.getDatafromDataBase()
        self.layoutFAB()
        objLoanDisplayViewModel.setHeaderView(headerView: viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCornerDisplay.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
       
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
