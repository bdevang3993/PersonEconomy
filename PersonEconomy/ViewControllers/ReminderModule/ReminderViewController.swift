//
//  ReminderViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/12/21.
//

import UIKit

class ReminderViewController: UIViewController {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplay: UITableView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    var objReminderViewModel = ReminderViewModel()
    var objUserReminderQuery = UserReminderQuery()
    var updateData:updateDataWhenBackClosure?
    var isFromEdit:Bool = false
    var dicData = [String:Any]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
    func configureData() {
        objReminderViewModel.setHeaderView(headerView: viewHeader, isFromEdit: isFromEdit)
        self.viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplay.delegate = self
        self.tblDisplay.dataSource = self
        btnSave.setUpButton()
        if isFromEdit == false {
            btnGpay.isHidden = true
            btnDelete.isHidden = true
            self.fetchid()
        } else {
            self.setUpData()
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewButton.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            viewButton.frame.size.height = (60.0 * (screenWidth/320.0))
        }
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let isValied = validateData()
        if isValied {
            if isFromEdit {
                self.updateInData()
            } else {
                self.saveinDatabase()
            }
        }
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        self.deleteInDatabase()
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnGpayClicked(_ sender: Any) {
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount =  objReminderViewModel.arrDescription[5]
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
