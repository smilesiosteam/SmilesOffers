//
//  DiscountAndDetailsValidityTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/25/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsValidityTableViewCellModel{
    var estimatedSavings = ""
    var validTillDate = ""
}


class DiscountAndDetailsValidityTableViewCell: SuperTableViewCell {
    
    //MARK- Outlets
    @IBOutlet weak var estimatedView: UIView!
    @IBOutlet weak var validTillView: UIView!

    @IBOutlet weak var titleHeadingLabel: UILabel! {
        didSet {
            titleHeadingLabel.text = "ValidTillTitle".localizedString
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var estimatedSavingsHeadingLabel: UILabel! {
        didSet {
            estimatedSavingsHeadingLabel.text = "EstimatedSavingTitle".localizedString
        }
    }
    
    @IBOutlet weak var estimatedSavingsLabel: UILabel!
    
    //MARK- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    //TODO: replace string with model
    class func rowModel(value: DiscountAndDetailsValidityTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsValidityTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsValidityTableViewCellModel{
            titleLabel.text = model.validTillDate
            estimatedSavingsLabel.text = model.estimatedSavings
            estimatedView.isHidden = model.estimatedSavings.isEmpty
            validTillView.isHidden = model.validTillDate.isEmpty
        }
    }
}
