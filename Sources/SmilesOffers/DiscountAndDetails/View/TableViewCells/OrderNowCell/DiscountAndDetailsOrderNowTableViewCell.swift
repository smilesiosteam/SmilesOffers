//
//  DiscountAndDetailsOrderNowTableViewCell.swift
//  House
//
//  Created by Shmeel Ahmed on 18/02/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsOrderNowTableModel {
    var titleValue: String?
    var btnTextValue: String?
    var imageURL: String?
    init() {}
}
class DiscountAndDetailsOrderNowTableViewCell: SuperTableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var orderNow: UILabel!
    @IBOutlet weak var paddedContainerView: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        paddedContainerView.RoundedViewConrner(cornerRadius: 12)
        paddedContainerView.addshadow(top: true, left: true, bottom: true, right: true, shadowRadius: 20, offset: CGSize.zero)
    }

    //MARK: Update Cell

    override func updateCell(rowModel: BaseRowModel) {
        super.updateCell(rowModel: rowModel)

        if let model = rowModel.rowValue as? DiscountAndDetailsOrderNowTableModel {
            self.titleLbl.text = model.titleValue.asStringOrEmpty()
            self.orderNow.text = model.btnTextValue.asStringOrEmpty()
            if let url = URL(string: model.imageURL ?? ""){
                self.icon.setImageWith(url, placeholderImage: #imageLiteral(resourceName: "iconPhoto"))
            }
        }
    }
    
    class func rowModel(model: DiscountAndDetailsOrderNowTableModel, delegate: BaseDataSourceDelegate?) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsOrderNowTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = model
        rowModel.delegate = delegate
        return rowModel
    }
}
