//
//  DiscountAndDetailsQuantityTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/14/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

protocol OfferSingleQuantityCellDelegate: AnyObject {
    func increaseSingleQuantity(withQuantity voucherQuantity: Int, forIndex index: Int, rowValue:DiscountAndDetailsQuantityTableViewCellModel)
    func decreaseSingleQuantity(withQuantity voucherQuantity: Int, forIndex index: Int,rowValue:DiscountAndDetailsQuantityTableViewCellModel)
}

class DiscountAndDetailsQuantityTableViewCellModel {
    
    var cellShouldEnable = true
    var voucherQuantity: Int?
    var delegate: OfferSingleQuantityCellDelegate?
    var isSoldOut: Bool?

    init(){}
    init(cellShouldEnable: Bool, voucherQuantity: Int?, delegate: OfferSingleQuantityCellDelegate?){
        self.cellShouldEnable = cellShouldEnable
        self.voucherQuantity = voucherQuantity
        self.delegate = delegate
    }
}

class DiscountAndDetailsQuantityTableViewCell: SuperTableViewCell {

    //MARK- Outlets
    @IBOutlet weak var quantityText: BaseLabel! {
        didSet {
            quantityText.text = "SelectQuantityTitle".localizedString
        }
    }
    @IBOutlet weak var increamentBtn: UIButton!
    @IBOutlet weak var decrementBtn: UIButton!
    @IBOutlet weak var numberOfItemsLabel: UILabel!

    //MARK- Properties
    weak var delegate: OfferSingleQuantityCellDelegate?
    private var voucherQuantity: Int?
    private var selectedIndex: Int?
    var selectedmodel: DiscountAndDetailsQuantityTableViewCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func enableCell(_ enable: Bool) {
        self.isUserInteractionEnabled = enable
    }
    
    // MARK: update cell
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsQuantityTableViewCellModel {
            selectedmodel = model
            self.enableCell(model.cellShouldEnable)
            self.delegate = model.delegate
            self.selectedIndex = rowModel.tag
            self.voucherQuantity = model.voucherQuantity ?? 1
            self.numberOfItemsLabel.text = "\(model.voucherQuantity ?? 1)"
            
            if let isSoldOut = model.isSoldOut, isSoldOut {
                increamentBtn.isUserInteractionEnabled = false
                decrementBtn.isUserInteractionEnabled = false
                increamentBtn.alpha = 0.5
                decrementBtn.alpha = 0.5
            } else {
                increamentBtn.isUserInteractionEnabled = true
                decrementBtn.isUserInteractionEnabled = true
                increamentBtn.alpha = 1
                decrementBtn.alpha = 1
            }
        }
    }

    
    @IBAction func increamentAction(_ sender: Any)
    {
        if let delegate = delegate {
            delegate.increaseSingleQuantity(withQuantity: self.voucherQuantity ?? 1, forIndex: self.selectedIndex.asIntOrEmpty(),rowValue: selectedmodel ?? DiscountAndDetailsQuantityTableViewCellModel())
        }
    }
    
    @IBAction func decrementAction(_ sender: Any)
    {
        if let delegate = delegate {
            delegate.decreaseSingleQuantity(withQuantity: self.voucherQuantity ?? 1, forIndex: self.selectedIndex.asIntOrEmpty(),rowValue: selectedmodel ?? DiscountAndDetailsQuantityTableViewCellModel())
        }
    }
    
    class func rowModel(value: DiscountAndDetailsQuantityTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsQuantityTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
}
