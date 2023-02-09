//
//  LICDisplayViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/02/21.
//

import UIKit
import Floaty
class LICDisplayViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblLICDisplay: UITableView!
    var objLICDisplayViewModel = LICDisplayViewModel()
    var floaty = Floaty()
    var floaty1 = Floaty()
    var objUserLICDetailsQuery = UserLICDetailsQuery()
    var arrLICData = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objLICDisplayViewModel.setHeaderView(headerView: viewHeader)
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
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
