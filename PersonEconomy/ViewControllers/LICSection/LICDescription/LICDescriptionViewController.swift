//
//  LICDescriptionViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit

class LICDescriptionViewController: UIViewController {

    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var viewBtnSubmit: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblLICDescription: UITableView!
    var dicLICDescription = [String:Any]()
    var objLICDescriptionViewModel = LICDescriptionViewModel()
    var objEntryPerMonth = LICEntryPerMonthQuery()
    var objUserLICDetailsQuery = UserLICDetailsQuery()
    var cdUpdateData:updateDataWhenBackClosure?
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objLICDescriptionViewModel.setHeaderView(headerView: viewHeader)
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        let validate = self.validation()
        if validate {
            self.updateinDatabase()
        }
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnGpayClicked(_ sender: Any) {
        
        if objLICDescriptionViewModel.arrDescription[3].isEmpty {
            Alert().showAlert(message: kAmountSelectOption, viewController: self)
            return
        }
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: LIC, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.isFromBack = true
        objSearchProduct.strDeductionAmount =  objLICDescriptionViewModel.arrDescription[3]
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
