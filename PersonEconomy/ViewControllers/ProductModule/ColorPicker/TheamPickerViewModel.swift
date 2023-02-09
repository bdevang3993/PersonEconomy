//
//  TheamPickerViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/08/21.
//

import Foundation
class TheamPickerViewModel:NSObject {
    var arrColorName = ["Main","Red","Orange","Green","Blue","Indigo","Violet"]
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Theme Picker"//"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(TheamPickerViewController(), action: #selector(TheamPickerViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func colorName(index:Int) -> String {
        switch index {
        case 0:
            return RainbowColor.main.selectedColor()
        case 1:
            return RainbowColor.red.selectedColor()
        case 2:
            return RainbowColor.orange.selectedColor()
        case 3:
            return RainbowColor.green.selectedColor()
        case 4:
            return RainbowColor.blue.selectedColor()
        case 5:
            return RainbowColor.indigo.selectedColor()
        case 6:
            return RainbowColor.violet.selectedColor()
        default:
            return RainbowColor.main.selectedColor()
        }
    }
}
extension TheamPickerViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objTheamPickerViewModel.arrColorName.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        } else {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "TheamTableViewCell") as! TheamTableViewCell
        cell.lblColorName.text = objTheamPickerViewModel.arrColorName[indexPath.row] + " Theme"
        let colorString = objTheamPickerViewModel.colorName(index: indexPath.row)
        cell.viewColor.backgroundColor = hexStringToUIColor(hex: colorString)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setAlertWithCustomAction(viewController: self, message: "Are you sure you want to change theam color?", ok: { (isSuccess) in
            let colorString = self.objTheamPickerViewModel.colorName(index: indexPath.row)
            let userDefault = UserDefaults.standard
            userDefault.setValue(colorString, forKey: kTheamColor)
            userDefault.synchronize()
            strTheamColor = colorString
            self.clUpdateColor!(true)
            self.dismiss(animated: true, completion: nil)
        }, isCancel: true) { (isSuccess) in
        }
        
       
    }
    
}
