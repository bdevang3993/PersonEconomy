//
//  AddProofViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/11/21.
//

import UIKit

class AddProofViewController: UIViewController {
    
    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewbtnDisplay: UIView!
    var objAddProofViewModel = AddProofViewModel()
    @IBOutlet weak var viewCorner: UIView!
    var objUserDataQuery = UserDataQuery()
    var updateData:updateDataWhenBackClosure?
    var dicDataForEdit = [String:Any]()
    var isfromEdit:Bool = false
    var struserMedicalId:String = ""
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    func configureData() {
        btnSave.setUpButton()
        self.viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        objAddProofViewModel.setHeaderView(headerView: self.viewHeader)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewbtnDisplay.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            viewbtnDisplay.frame.size.height = (60.0 * (screenWidth/320.0))
        }
        if isfromEdit {
            self.setupData()
        }
    }
    func setupData() {
        if let name = dicDataForEdit["name"] {
            objAddProofViewModel.arrDescription[0] = (name as! String)
        }
        if let date = dicDataForEdit["endDate"] {
            objAddProofViewModel.arrDescription[1] = (date as! String)
        }
        if let imageData = dicDataForEdit["image"] {
            objAddProofViewModel.imageData = imageData as! Data
        }
        if let amount = dicDataForEdit["price"] {
            objAddProofViewModel.arrDescription[2] =  amount as! String
        }
    }
    @IBAction func btnGpayClicked(_ sender: Any) {
        if objAddProofViewModel.arrDescription[2].isEmpty {
            Alert().showAlert(message: kAmountSelectOption, viewController: self)
            return
        }
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
               objSearchProduct.modalPresentationStyle = .overFullScreen
               objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount =  objAddProofViewModel.arrDescription[2]
               self.present(objSearchProduct, animated: true, completion: nil)
        
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        let valied = self.validation()
        if valied  && isfromEdit {
            self.updateDataBase()
        } else if valied {
            self.saveData()
        }
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
