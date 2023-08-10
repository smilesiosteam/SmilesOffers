//
//  BulletCell.swift
//  House
//
//  Created by Faraz Haider on 23/11/2021.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import UIKit
import SmilesUtilities

class DiscountAndDetailsBulletCellModel {
    var detailText: String?
}


class DiscountAndDetailsBulletCell: SuperTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //TODO: replace string with model
    class func rowModel(value: DiscountAndDetailsBulletCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsBulletCell"
        rowModel.rowValue = value
        rowModel.rowHeight = UITableView.automaticDimension
    
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsBulletCellModel {
            titleLabel.text = model.detailText ?? ""
        }
    }
}
