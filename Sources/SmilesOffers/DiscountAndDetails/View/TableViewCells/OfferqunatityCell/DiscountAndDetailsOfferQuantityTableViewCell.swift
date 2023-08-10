//
//  OfferQuantityTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/20/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

protocol OfferQuantityTableViewCellDelegate: AnyObject {
    func expandCollapse(index: Int)
    func increaseQuantity(withQuantity voucherQuantity: Int, forIndex index: Int,rowModel: DiscountAndDetailsOfferQuantityTableViewCellModel)
    func decreaseQuantity(withQuantity voucherQuantity: Int, forIndex index: Int, rowModel:DiscountAndDetailsOfferQuantityTableViewCellModel)
    func offerQuantityCell(_ cell: DiscountAndDetailsOfferQuantityTableViewCell, didReloadCell isExpanded: Bool)
}

class DiscountAndDetailsOfferQuantityTableViewCellModel {
    
    var cellTitle: String = ""
    var cellDescription: String = ""
    var cellPrice: String = ""
    var isSelected = false
    var delegate: OfferQuantityTableViewCellDelegate?
    var voucherQuantity: Int?
    var pointsDescription: String?
    var isPriceCellExpanded: Bool?
    var strikeThroughPrice: Bool?
    var isSoldOut: Bool?
    var isAccountTotalLimit = true
    var isFree = false
    
    init(){}
    
    init(cellTitle: String, cellDescription: String, cellPrice: String, voucherQuantity: Int?, isAccountTotalLimit:Bool, isFree:Bool, pointsDescription: String?, delegate: OfferQuantityTableViewCellDelegate?,isPriceCellExpanded: Bool?, strikeThroughPrice: Bool? = false){
        self.cellTitle = cellTitle
        self.cellDescription = cellDescription
        self.cellPrice = cellPrice
        self.voucherQuantity = voucherQuantity
        self.pointsDescription = pointsDescription
        self.delegate = delegate
        self.isPriceCellExpanded = isPriceCellExpanded
        self.strikeThroughPrice = strikeThroughPrice
        self.isAccountTotalLimit = isAccountTotalLimit
        self.isFree = isFree
        if !isAccountTotalLimit{
            self.voucherQuantity = 1
        }
    }
}

class DiscountAndDetailsOfferQuantityTableViewCell: SuperTableViewCell {
    
    //MARK- Outlets
    @IBOutlet weak var offerDescriptionView: UIView!
    @IBOutlet weak var offerSelectionButton: UIButton!
    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var increamentBtn: UIButton!
    @IBOutlet weak var decrementBtn: UIButton!
    @IBOutlet weak var offerPointsLabel: UILabel!

    //MARK- Properties
    weak var delegate: OfferQuantityTableViewCellDelegate?
    private var selectedIndex: Int?
    private var voucherQuantity: Int?
    
    let readmoreFont = UIFont.latoBoldFont(size: 12.0)
    let readmoreFontColor = UIColor.appPurpleColor1
    
    var descriptionText = ""
    var isDescExpanded = false
    var addReadLess = false
    var selectedModel : DiscountAndDetailsOfferQuantityTableViewCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: update cell
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsOfferQuantityTableViewCellModel {
            selectedModel = model
            self.isDescExpanded = model.isPriceCellExpanded.asBoolOrFalse()
            self.descriptionText = model.cellDescription
            
            self.delegate = model.delegate
            self.selectedIndex = rowModel.tag
            self.voucherQuantity = model.voucherQuantity ?? 1
            
            if rowModel.isSelected {
                self.cellSelectedState()
            } else {
                self.cellNonSelectedState()
            }
            self.numberOfItemsLabel.text = "\(model.voucherQuantity ?? 1)"
            self.offerTitleLabel.text = model.cellTitle
            self.offerPriceLabel.text = model.cellPrice
            
            if let pointsDescription = model.pointsDescription, !pointsDescription.isEmpty {
                self.offerPointsLabel.isHidden = false
                if let discountedAmount = model.strikeThroughPrice, discountedAmount {
                    self.offerPointsLabel.attributedText = SwiftUtli.strikeOutString(string: pointsDescription)
                } else {
                    self.offerPointsLabel.text = pointsDescription
                }
            } else {
                self.offerPointsLabel.isHidden = true
            }
            
            self.offerDescriptionLabel.text = model.cellDescription
            
            self.adjustDescriptionHeight(label: self.offerDescriptionLabel, fullText: self.descriptionText, addReadLess: self.addReadLess)

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
    
    
    func adjustDescriptionHeight(label: UILabel, fullText: String, addReadLess: Bool) {
        if label.countLabelLines() > 3, !isDescExpanded {
            label.numberOfLines = 3
            self.offerDescriptionLabel.text = fullText + "... " + "ReadMore".localizedString
            let readmoreFont = UIFont.latoBoldFont(size: 12.0)
            let readmoreFontColor = UIColor.appPurpleColor1
            label.layoutIfNeeded()
            label.addTrailing(with: "... ", fullText: fullText, moreText: "ReadMore".localizedString, moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelDescriptionAction(gesture:)))
            label.gestureRecognizers?.removeAll()
            label.addGestureRecognizer(tap)
            label.isUserInteractionEnabled = true
            tap.delegate = self
        }
        else {
            if addReadLess {
                let readmoreFont = UIFont.latoBoldFont(size: 12.0)
                let readmoreFontColor = UIColor.appPurpleColor1
                label.numberOfLines = 0
                self.offerDescriptionLabel.text = fullText + "... " + "ReadLess".localizedString
                label.layoutIfNeeded()
                label.addTrailing(with: ". ", fullText: fullText, moreText: "ReadLess".localizedString, moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
            }
            else {
                label.text = fullText
            }
        }
    }
    
    @objc func labelDescriptionAction(gesture: UITapGestureRecognizer) {
        if offerDescriptionLabel.numberOfLines == 3 {
            self.isDescExpanded = true
        }
        else {
            self.isDescExpanded = false
        }
        self.delegate?.offerQuantityCell(self, didReloadCell: self.isDescExpanded)
        
    }
    
    func cellSelectedState() {
        self.offerDescriptionView.isHidden = !(selectedModel?.isAccountTotalLimit ?? true)
        self.offerSelectionButton.setImage(UIImage(named: "SingleSelectionSelected"), for: .normal)
        
    }
    
    func cellNonSelectedState() {
        self.offerDescriptionView.isHidden = true
        self.offerSelectionButton.setImage(UIImage(named: "SingleSelectionUnSelected"), for: .normal)
    }
    
    @IBAction func expandAction(_ sender: UIButton)
    {
        if let delegate = delegate {
            delegate.expandCollapse(index: self.selectedIndex.asIntOrEmpty())
        }
    }
    
    @IBAction func increamentAction(_ sender: Any)
    {
        if let delegate = delegate {
            delegate.increaseQuantity(withQuantity: self.voucherQuantity ?? 1, forIndex: self.selectedIndex.asIntOrEmpty(),rowModel : selectedModel ?? DiscountAndDetailsOfferQuantityTableViewCellModel())
        }
    }
    
    @IBAction func decrementAction(_ sender: Any)
    {
        if let delegate = delegate {
            delegate.decreaseQuantity(withQuantity: self.voucherQuantity ?? 1, forIndex: self.selectedIndex.asIntOrEmpty(),rowModel : selectedModel ?? DiscountAndDetailsOfferQuantityTableViewCellModel())
        }
    }
    
    
    //TODO: replace string with model
    class func rowModel(value: DiscountAndDetailsOfferQuantityTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsOfferQuantityTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
}
