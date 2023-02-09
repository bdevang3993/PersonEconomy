//
//  ProofTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/11/21.
//

import UIKit

class ProofTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnGpay: UIButton!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblExpiredDate: UILabel!
    @IBOutlet weak var imgDisplay: UIImageView!
    var selectedIndex:TASelectedIndex?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnGpayClicked(_ sender: UIButton) {
        selectedIndex!(sender.tag)
    }
}
