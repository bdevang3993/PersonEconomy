//
//  LICDetailViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit

class LICDetailViewController: UIViewController {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblLICDetails: UITableView!
    var objLICDetailViewModel = LICDetailViewModel()
    var strpolicyNumber:String = ""
    var objLICEntryPerMonthQuery = LICEntryPerMonthQuery()
    var objUserLICDetailsQuery = UserLICDetailsQuery()
    var arrDisplayData = [[String:Any]]()
    var csUpdateData:updateDataWhenBackClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objLICDetailViewModel.setHeaderView(headerView: viewHeader)
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }

    @objc func backCliked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        self.deleteData()
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
