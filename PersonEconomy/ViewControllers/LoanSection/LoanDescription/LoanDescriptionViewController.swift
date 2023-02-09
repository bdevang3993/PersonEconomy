//
//  LoanDescriptionViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 27/01/21.
//

import UIKit

class LoanDescriptionViewController: UIViewController {
    @IBOutlet weak var viewBtnSubmit: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    
    @IBOutlet weak var btnGpay: UIButton!
    let objLoanDescription = LoanDescriptionViewModel()
    var objUserLoanDetailsQuery = UserLoanDetailsQuery()
    var objLoanEntry_PerMonthQuery = LoanEntry_PerMonthQuery()
    var clUpdateData:updateDataWhenBackClosure?
    @IBOutlet weak var btnSave: UIButton!
    var arrLoanDetails = [String:Any]()
    var strBankName:String = ""
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objLoanDescription.setHeaderView(headerView: viewHeader, isfromSignUp: false)
        self.fetchLoanDetail()
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
       let data = self.updateAllData()
        if data {
            self.updateInDatabase()
        }
    }
    @objc func backCliked() {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func btnGpayClicked(_ sender: Any) {
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount =  objLoanDescription.arrDescription[1]
        self.present(objSearchProduct, animated: true, completion: nil)
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
