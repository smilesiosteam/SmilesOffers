//
//  DiscoubntAndDetailsSoldOutTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/14/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsSoldOutTableViewCellModel {
    
    var title: String = ""
    var subTitle: String = ""
}


class DiscountAndDetailsSoldOutTableViewCell: SuperTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //TODO: replace string with model
    class func rowModel(value: DiscountAndDetailsSoldOutTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsSoldOutTableViewCell"
        rowModel.rowValue = value
        rowModel.rowHeight = UITableView.automaticDimension
    
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsSoldOutTableViewCellModel {
            titleLabel.text = model.title
            subTitleLabel.text = model.subTitle
        }
    }
}
