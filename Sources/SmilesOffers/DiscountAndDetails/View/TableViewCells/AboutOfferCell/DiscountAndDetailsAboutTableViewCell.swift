//
//  DiscountAndDetailsAboutTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/25/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

protocol DiscountAndDetailsAboutTableViewCellDelegate: AnyObject {
    func aboutCell(_ cell: DiscountAndDetailsAboutTableViewCell, didReloadCell isExpanded: Bool)
}

class DiscountAndDetailsAboutTableViewCellModel {
    
    var isDescExpanded = false
    var addReadLess = false
    var description = ""
    
    init(isDescExpanded: Bool, description: String, addReadLess: Bool){
        self.isDescExpanded = isDescExpanded
        self.addReadLess = addReadLess
        self.description = description
    }
}
class DiscountAndDetailsAboutTableViewCell: SuperTableViewCell {
    
    @IBOutlet weak var aboutResturantLabel: UILabel!
    @IBOutlet weak var aboutResturantDescription: UILabel! {
        didSet {
            aboutResturantDescription.font = UIFont.latoRegularFont(size: 12)
            aboutResturantDescription.textColor = .lightGray
        }
    }
    
    weak var delegate: DiscountAndDetailsAboutTableViewCellDelegate?
    
    let readmoreFont = UIFont.latoBoldFont(size: 12.0)
    let readmoreFontColor = UIColor.appPurpleColor1
    
    var descriptionText = ""
    var isDescExpanded = false
    var addReadLess = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsAboutTableViewCellModel {
            self.isDescExpanded = model.isDescExpanded
            self.descriptionText = model.description
            self.addReadLess = model.addReadLess
        }
        
        self.delegate = rowModel.delegate as? DiscountAndDetailsAboutTableViewCellDelegate
        self.aboutResturantDescription.text = self.descriptionText
        self.aboutResturantLabel.text = "AboutTitle".localizedString + " " + rowModel.rowTitle
        self.adjustDescriptionHeight(label: self.aboutResturantDescription, fullText: self.aboutResturantDescription.text ?? "", addReadLess: self.addReadLess)
    }
    
    func adjustDescriptionHeight(label: UILabel, fullText: String, addReadLess: Bool) {
        let labelLines = label.maxNumberOfLines
        if labelLines > 3, !(self.isDescExpanded) {
            label.numberOfLines = 3
            self.aboutResturantDescription.text = fullText + "... " + "ReadMore".localizedString
            DispatchQueue.main.async {
                label.addTrailing(with: "... ", fullText: fullText, moreText: "ReadMore".localizedString, moreTextFont: self.readmoreFont, moreTextColor: self.readmoreFontColor)
            }
            
        } else {
            if addReadLess {
                label.numberOfLines = 0
                self.aboutResturantDescription.text = fullText + "... " + "ReadLess".localizedString
                DispatchQueue.main.async {
                    label.addTrailing(with: " ", fullText: fullText, moreText: "ReadLess".localizedString, moreTextFont: self.readmoreFont, moreTextColor: self.readmoreFontColor)
                }
            } else {
                label.text = fullText
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelDescriptionAction(gesture:)))
        label.gestureRecognizers?.removeAll()
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        tap.delegate = self
    }
    
    @objc func labelDescriptionAction(gesture: UITapGestureRecognizer) {
        if aboutResturantDescription.numberOfLines == 3 {
            self.isDescExpanded = true
        }
        else {
            self.isDescExpanded = false
        }
        self.delegate?.aboutCell(self, didReloadCell: self.isDescExpanded)
        
    }
    //TODO: replace string with model
    class func rowModel(value: DiscountAndDetailsAboutTableViewCellModel, delegate: DiscountAndDetailsAboutTableViewCellDelegate) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsAboutTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        rowModel.delegate = delegate
        return rowModel
    }
}
