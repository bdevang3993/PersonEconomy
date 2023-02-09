//
//  TheamPickerViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/08/21.
//

import UIKit
typealias taUpdateColor = (Bool) -> Void
class TheamPickerViewController: UIViewController {
    @IBOutlet weak var viewBackGroundColor: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objTheamPickerViewModel = TheamPickerViewModel()
    var clUpdateColor:taUpdateColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    func configureData() {
        objTheamPickerViewModel.setHeaderView(headerView: viewHeader)
        viewBackGroundColor.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.tableFooterView = UIView()
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
