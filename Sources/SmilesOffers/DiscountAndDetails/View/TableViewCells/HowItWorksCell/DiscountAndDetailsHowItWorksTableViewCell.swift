//
//  DiscountAndDetailsHowItWorksTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/25/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsHowItWorksTableModel {
    var titleValue: String?
    init() {}
}
class DiscountAndDetailsHowItWorksTableViewCell: SuperTableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Update Cell

    override func updateCell(rowModel: BaseRowModel) {
        super.updateCell(rowModel: rowModel)

        if let model = rowModel.rowValue as? DiscountAndDetailsHowItWorksTableModel {
            self.titleLbl.text = model.titleValue.asStringOrEmpty()
        }
    }
    
    //TODO: replace string with model
    
    class func rowModel(model: DiscountAndDetailsHowItWorksTableModel, delegate: BaseDataSourceDelegate?) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsHowItWorksTableViewCell"
        rowModel.rowHeight = 56.0
        rowModel.rowValue = model
        rowModel.delegate = delegate
        return rowModel
    }
}
