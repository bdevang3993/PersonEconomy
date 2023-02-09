//
//  SearchProductViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 03/09/21.
//

import UIKit
import Floaty

class SearchProductViewController: UIViewController {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    var isFromBack:Bool = false
    var strDeductionAmount:String = "0"
    var objPayerListViewModel = SearchPayerDataViewModel()
    var floaty = Floaty()
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
    
    func configureData() {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
       
        txtSearch.delegate = self
        self.lblNoData.isHidden = true
        self.lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
            txtSearch.placeholder = "Sales Name"
            objPayerListViewModel.tableView = self.tblDisplayData
            objPayerListViewModel.viewController = self
        objPayerListViewModel.fetchAllData(lblNoData: lblNoData, view: self.view)
        objPayerListViewModel.setHeaderView(headerView: viewHeader, isFromBack: isFromBack)
        self.layoutFAB()
       
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplayData.tableFooterView = UIView()
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
