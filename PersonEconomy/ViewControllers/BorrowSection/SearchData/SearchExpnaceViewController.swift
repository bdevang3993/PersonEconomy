//
//  SearchViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/03/21.
//

import UIKit
import Floaty
import IQKeyboardManagerSwift

class SearchExpnaceViewController: UIViewController {
    
    @IBOutlet weak var imgDownType: UIImageView!
    @IBOutlet weak var imgDownName: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblSearchData: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    var objSearchExpenseViewModel = SearchExpnaceModel()
    var objUserAdvanceModel = UserAdvanceQuery()
    var totoalAmount:Double = 0
    var floaty = Floaty()
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configData()
        self.getNameList()
        backupDatabase(backupName: kPersonDataBase)
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
        
    @IBAction func btnNameClicked(_ sender: Any) {
        self.pickData()
    }
    @IBAction func btnSearchClicked(_ sender: Any) {
        if self.txtName.text! == "" {
            Alert().showAlert(message: "please select name first", viewController: self)
            return
        }
        IQKeyboardManager.shared.resignFirstResponder()
        PickerView.objShared.setUPickerWithValue(arrData: ["Borrow","Paied","Advance"], viewController: self) { (selectedValue) in
            self.txtType.text = selectedValue
            self.fetchDataWithType(name: self.txtName.text!, type: selectedValue)
        }
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
