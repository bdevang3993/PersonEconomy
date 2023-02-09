//
//  AddPayerDetailViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import UIKit
import Vision

class AddPayerDetailViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var lblQRCode: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnQRCode: UIButton!
    
    var strUpiLink:String = ""
    var strAmount:String = "0"
    var payerDetailsQuery = PayerDetailsQuery()
    var isFromAddItem:Bool = true
    var updateAllData:updateDataWhenBackClosure?
    let objImagePickerViewModel = ImagePickerViewModel()
    let objAddPayerDetailViewModel = AddPayerDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.fetchId()
        objAddPayerDetailViewModel.setHeaderView(headerView: viewHeader)
        btnSave.setUpButton()
        btnPay.setUpButton()
        txtAmount.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        txtAmount.attributedPlaceholder = NSAttributedString(string: txtAmount.placeholder!,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtAmount.isHidden = true
        
        btnPay.isHidden = true
        if isFromAddItem == false {
            btnQRCode.isHidden = true
            lblQRCode.isHidden = true
            btnSave.isHidden = true
            txtAmount.text = strAmount
            txtAmount.isHidden = false
            txtBusinessName.text = objAddPayerDetailViewModel.objPayerData.strName
            objAddPayerDetailViewModel.newId = objAddPayerDetailViewModel.objPayerData.id
            self.btnPay.isHidden = false
            self.createQRCode()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @IBAction func btnQRCodeClicked(_ sender: Any) {
        self.alertForImage()
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if self.txtBusinessName.text!.count <= 0 {
            Alert().showAlert(message: "please provide business name", viewController: self)
            return
        }
        if self.objAddPayerDetailViewModel.strURlLink.count <= 0 {
            Alert().showAlert(message: "please selet QRCode", viewController: self)
            return
        }
        setAlertWithCustomAction(viewController: self, message: "Are you sure you have save this entry?", ok: { (isSuccess) in
            self.saveInDatabase()
        }, isCancel: false) { (isFailed) in
        }
    }
    func createQRCode() {
        strUpiLink = objAddPayerDetailViewModel.objPayerData.strURL
        if txtAmount.text!.count > 0 {
            if strUpiLink.contains("&am=") {
                
            }else{
                strUpiLink = strUpiLink.appending("&am=\(txtAmount.text ?? "0")")
            }
        }
       
        let data = strUpiLink.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
       let qrcodeImage = filter?.outputImage
        let scaleX = qrImage.frame.size.width / qrcodeImage!.extent.size.width
        let scaleY = qrImage.frame.size.height / qrcodeImage!.extent.size.height
        let transformedImage = qrcodeImage!.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrImage.image = UIImage(ciImage: transformedImage)
    }
    
    @IBAction func btnPayClicked(_ sender: Any) {
        if txtAmount.text!.count >  0 {
            strUpiLink = objAddPayerDetailViewModel.objPayerData.strURL
            if txtAmount.text!.count > 0 {
                self.createQRCode()
                let url = NSURL(string: strUpiLink)! as URL
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:]) { (isSuccess) in
                        if isSuccess {
                            Alert().showAlert(message: "Payment successfully", viewController: self)
                        } else {
                            Alert().showAlert(message: "Payment failed please try again", viewController: self)
                        }
                    }
                } else {
                    Alert().showAlert(message: "Can't open url on this device", viewController: self)
                }
            }
        } else {
            Alert().showAlert(message: "please provide amount", viewController: self)
        }
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
