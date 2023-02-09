//
//  TextFieldWithLabelTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 09/01/21.
//

import UIKit

class TextFieldWithLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtDescription: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        txtDescription.setLeftPaddingPoints(10.0)
        lblTitle.textColor = hexStringToUIColor(hex: strTheamColor)
        // Configure the view for the selected state
    }

}
