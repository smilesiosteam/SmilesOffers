//
//  DiscountAndDetailsRedeemedOfferTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/14/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsRedeemedOfferTableViewCellModel{
    var title = ""
}

class DiscountAndDetailsRedeemedOfferTableViewCell: SuperTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func rowModel(value : DiscountAndDetailsRedeemedOfferTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsRedeemedOfferTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsRedeemedOfferTableViewCellModel{
            titleLabel.text = model.title
        }
    }
}
