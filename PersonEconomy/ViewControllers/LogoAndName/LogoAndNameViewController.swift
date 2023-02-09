//
//  LogoAndNameViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/03/21.
//

import UIKit

class LogoAndNameViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnImagePick: UIButton!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var lblCompanyLogo: UILabel!
    @IBOutlet weak var lblQRCode: UILabel!
    
    @IBOutlet weak var btnQRCode: UIButton!
    var objLogoViewModel = LogoAndNameViewModel()
    var  objImagePickerViewModel = ImagePickerViewModel()
    var payerDetailsQuery = PayerDetailsQuery()
    var newId:Int = -1
    var strURlLink:String = ""
    var arrPayerData = [PayerData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfigureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnImagePickClicked(_ sender: Any) {
        self.pickImage()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        
        let userDefault = UserDefaults.standard
        
        if self.txtCompanyName.text!.count <= 0 {
            Alert().showAlert(message: "please provide company name", viewController: self)
        } else if self.txtNumber.text!.count <= 0 {
            Alert().showAlert(message: "please provide contact number", viewController: self)
        }
        else {
            userDefault.set(self.txtCompanyName.text, forKey: kCompanyName)
            userDefault.set(self.txtNumber.text, forKey: kContactNumber)
        }
        if imgView.image != nil {
            let success = self.saveImage(image: self.imgView.image!,name:kLogo)
            if success {
                userDefault.set(kLogo, forKey: kLogo)
                userDefault.synchronize()
                setAlertWithCustomAction(viewController: self, message: "Data saved", ok: { (isSuccess) in
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isSuccess) in
                }
            }
            else {
                Alert().showAlert(message: "Please save logo another time", viewController: self)
            }
        } else {
            Alert().showAlert(message: "please select logo", viewController: self)
        }
        if imgQRCode.image != nil {
            let success = self.saveImage(image: self.imgQRCode.image!,name:kQRCode)
            let data = self.imgQRCode.image!.parseQR()
            if data.count > 0 {
                strURlLink = data[0]
            }
            if success {
                userDefault.set(kQRCode, forKey: kQRCode)
                userDefault.synchronize()
                self.saveInQRDatabase()
                setAlertWithCustomAction(viewController: self, message: "Data saved", ok: { (isSuccess) in
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isSuccess) in
                }
            } else {
                Alert().showAlert(message: "Please save QRCode another time", viewController: self)
            }
        }
    }
    
    @IBAction func btnQRCodeClicked(_ sender: Any) {
        objImagePickerViewModel.openGallery(viewController: self)
        objImagePickerViewModel.selectedImageFromGalary = {[weak self] selectedImage in
            self?.imgQRCode.image = selectedImage
        }
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
