//
//  HospitalDataViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 10/02/21.
//

import UIKit
import Floaty
class HospitalDataViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewCorner: UIView!
    var floaty = Floaty()
    var objHospitalDataViewModel = HospitalDataViewModel()
    var objUserMedicalQuery = UserMedicalQuery()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objHospitalDataViewModel.setHeaderView(headerView: viewHeader)
        self.setConfigureData()
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
