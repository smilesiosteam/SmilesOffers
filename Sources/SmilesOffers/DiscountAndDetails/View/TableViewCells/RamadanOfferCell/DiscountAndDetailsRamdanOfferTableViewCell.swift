//
//  DiscountAndDetailsRamdanOfferTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/16/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsRamdanOfferTableViewCellModel{
    var title  = ""
}

class DiscountAndDetailsRamdanOfferTableViewCell: SuperTableViewCell {
    @IBOutlet weak var promotionalTextLabel: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.RoundedViewConrner(cornerRadius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //TODO: replace string with model
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsRamdanOfferTableViewCellModel {
            promotionalTextLabel.text = model.title
        }
    }
    
    class func rowModel(value : DiscountAndDetailsRamdanOfferTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsRamdanOfferTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
}
