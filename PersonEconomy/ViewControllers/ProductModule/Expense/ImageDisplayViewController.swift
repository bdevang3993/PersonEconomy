//
//  ImageDisplayViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/03/21.
//

import UIKit

class ImageDisplayViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var imgView: UIImageView!
    var objImageDisplay = ImageDisplayViewModel()
    var imageData = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objImageDisplay.setHeaderView(headerView: self.viewHeader)
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    func configureData(){
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.imgView.image = UIImage(data: imageData)
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
