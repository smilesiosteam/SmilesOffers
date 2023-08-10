//
//  DiscountAndDetailsTermsAndConditionsTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/17/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsTermsAndConditionsTableViewCell: SuperTableViewCell {
    @IBOutlet weak var tAndCLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        self.tAndCLabel.text = rowModel.rowValue as? String
    }
    
    class func rowModel(value: String) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsTermsAndConditionsTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
    
}
