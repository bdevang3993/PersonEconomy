//
//  DevidePersonViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 23/11/21.
//

import UIKit

class DevidePersonViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var btnSave: UIButton!
    var objUserAdvanceQuery = UserAdvanceQuery()
    var objUserExpanseQuery = UserExpenseQuery()
    var objDevidePersonViewModel = DevidePersonViewModel()
    var totalAmount:Int = 0
    var devidedPrice:Double = 0
    var userExpanseId:String = ""
    var selectedDate:String = ""
    var updateData:TaSelectedValueSuccess?
    var objExpenseAllData = [String:Any]()
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
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.saveInDatabase()
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
