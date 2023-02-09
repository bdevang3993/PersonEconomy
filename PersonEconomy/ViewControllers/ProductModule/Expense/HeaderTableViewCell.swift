//
//  HeaderTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 08/01/21.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        lblItemName.textColor = hexStringToUIColor(hex: strTheamColor)
        lblPrice.textColor = hexStringToUIColor(hex: strTheamColor)
        if lblDate != nil {
            lblDate.textColor = hexStringToUIColor(hex: strTheamColor)
        }
        
    }

}
