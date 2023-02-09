//
//  AddLoanDetailViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit

class AddLoanDetailViewController: UIViewController {

    @IBOutlet weak var viewBtnSave: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tblLoanDescription: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    var objLoanDetails = UserLoanDetailsQuery()
    var objLoanEntry = LoanEntry_PerMonthQuery()
    var dicLoanDetails = [String:Any]()
    let objAddLoanDetails = AddLoanDetailsViewModel()
    var isFromLonaDetails:Bool = false
    var updateData:updateDataWhenBackClosure?
    var endDate:String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfiguration()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    func setConfiguration() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtnSave.frame.size.height = (90.0 * (screenWidth/768.0))
              } else {
                viewBtnSave.frame.size.height = (60.0 * (screenWidth/320.0))
              }

        self.setMemberName()
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        objAddLoanDetails.isFromLonaDetails = isFromLonaDetails
        objAddLoanDetails.setHeaderView(headerView: viewHeader)
        objAddLoanDetails.setupDescription()
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        if isFromLonaDetails {
            self.setupAllData()
        }
        tblLoanDescription.delegate = self
        tblLoanDescription.dataSource = self
        btnSave.setUpButton()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
      let value =  self.setupValidation()
        if value {
            var dataSaved:Bool = false
            if !isFromLonaDetails {
                self.calculateMonths()
                dataSaved =  objLoanDetails.saveLoanDetail(loanType: objAddLoanDetails.arrDescription[1], loanId: objAddLoanDetails.arrDescription[2], memberName: objAddLoanDetails.arrDescription[0], deductionAmount: objAddLoanDetails.arrDescription[3], startDate: objAddLoanDetails.arrDescription[4], endDate: endDate, totalAmount: objAddLoanDetails.arrDescription[6], contactPerson: objAddLoanDetails.arrDescription[8], referenceNumber: objAddLoanDetails.arrDescription[9], bankName: objAddLoanDetails.arrDescription[7])
                self.setupallDateandAddInDatabase(month: objAddLoanDetails.arrDescription[5])
            }
            if dataSaved {
                
                let alertController = UIAlertController(title: kAppName, message: "You have added data successfully.", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    backupDatabase(backupName: kPersonDataBase)
                    self.updateData!()
                    self.backClicked()
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func calculateMonths() {
        endDate = objAddLoanDetails.countEndDate(strDate: objAddLoanDetails.arrDescription[4], month: objAddLoanDetails.arrDescription[5])
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
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
