//
//  LoanHeaderTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit

class LoanHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var TypeofLoan: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
