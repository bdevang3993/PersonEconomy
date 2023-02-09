//
//  TermsAndConditionViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 19/08/21.
//

import Foundation

class TermsAndConditionViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
         headerView.frame = headerViewXib!.bounds
            headerViewXib!.lblTitle.text = "Privacy Policy"
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib!.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(TermsAndConditionViewController(), action: #selector(TermsAndConditionViewController.backClicked), for: .touchUpInside)
        
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}





