//
//  PaySomeAmountViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/09/21.
//

import UIKit

class PaySomeAmountViewController: UIViewController {
    
    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var viewBtnSubmit: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    var updateAllData:updateDataWhenBackClosure?
    var objPaySomeAmountViewModel = PaySomeAmountViewModel()
    var objUserAdvanceQuery = UserAdvanceQuery()
    var objUserExpenseQuery = UserExpenseQuery()
    var totalAmount:Double = 0
    var arrBorrowDetail = [[String:Any]]()
    var isFromSelectDate:Bool = false
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if isFromSelectDate {
            let valied = self.checkForDateValidation()
            if  valied {
                self.deleteEntrybetweenDatesFromDatabase()
            }
        } else {
            let valied = self.checkForValidation()
            if valied {
                self.updateInDatabase()
            }
        }
    }
    @IBAction func btnGpayClicked(_ sender: Any) {
        if objPaySomeAmountViewModel.arrDescription[1].isEmpty {
            Alert().showAlert(message: kAmountSelectOption, viewController: self)
            return
        }
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
               objSearchProduct.modalPresentationStyle = .overFullScreen
               objSearchProduct.isFromBack = true
               objSearchProduct.strDeductionAmount =  objPaySomeAmountViewModel.arrDescription[1]
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
