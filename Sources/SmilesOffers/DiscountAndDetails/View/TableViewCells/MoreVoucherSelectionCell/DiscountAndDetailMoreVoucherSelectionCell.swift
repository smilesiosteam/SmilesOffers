//
//  DiscountAndDetailMoreVoucherSelectionCell.swift
//  House
//
//  Created by Faraz Haider on 25/11/2021.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailMoreVoucherSelectionCellModel{
    var voucherDenominations: VoucherDenomination?
    var isSelectedVoucher = false
    
}

class DiscountAndDetailMoreVoucherSelectionCell: SuperTableViewCell {
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var voucherValueLabel: UILabel!
    @IBOutlet weak var redeemUsingTitleLabel: UILabel!
    @IBOutlet weak var redeemPointsLabel: UILabel!
    @IBOutlet weak var redeemCostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //TODO: replace string with model
    class func rowModel(value: DiscountAndDetailMoreVoucherSelectionCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailMoreVoucherSelectionCell"
        rowModel.rowValue = value
        rowModel.rowHeight = 78
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailMoreVoucherSelectionCellModel {
            
            let ptsString = "Points_short".localizedString
            let aedString = "AED".localizedString
            let orString = "OrTitle".localizedString
            voucherTitleLabel.text = "VoucherOfTitle".localizedString
            redeemUsingTitleLabel.text = "RedeemUsingTitle".localizedString
            
            if let voucherObject = model.voucherDenominations{
                let voucherDirhamValue = "\(CommonMethods.numberFormatterDecimalStyle(voucherObject.denominationAED.asIntOrEmpty()) ?? "")  \(aedString)"
                let redeemDirhamValue = "\(orString.lowercased()) \(CommonMethods.numberFormatterDecimalStyle(voucherObject.denominationAED.asIntOrEmpty()) ?? "") \(aedString)"
                let redeemPointsValue = "\(CommonMethods.numberFormatterDecimalStyle(voucherObject.denominationPoint.asIntOrEmpty()) ?? "") \(ptsString)"
                
                redeemPointsLabel.text = redeemPointsValue
                redeemCostLabel.text = redeemDirhamValue
                voucherValueLabel.text = voucherDirhamValue
                
                if LanguageManager.sharedInstance().currentLanguage == English {
                    voucherValueLabel.font = UIFont(name: "NeoTechAlt-Medium", size: 30)
                } else {
                    voucherValueLabel.font = UIFont(name: "NeoTechAlt".localizedString, size: 30)
                }
                
            }
            
            
            var redeemCostStyledStringsArray = [Any]()
            
            var orStyledStringDic: [String : Any] = [:]
            orStyledStringDic["string"] = orString.lowercased()
            orStyledStringDic["fontStyle"] = UIFont(name: LanguageManager.sharedInstance().getLocalizedString(forKey: "Lato-Regular"), size: 12.0)
            
            var aedStyledStringDic: [String : Any] = [:]
            aedStyledStringDic["string"] = aedString
            aedStyledStringDic["fontStyle"] = UIFont(name: LanguageManager.sharedInstance().getLocalizedString(forKey: "Lato-Regular"), size: 11.0)
            
            
            var redeemPointsStyledStringsArray = [Any]()
            
            var redeemPointsStyledStringDic: [String : Any] = [:]
            redeemPointsStyledStringDic["string"] = ptsString
            redeemPointsStyledStringDic["fontStyle"] = UIFont(name: LanguageManager.sharedInstance().getLocalizedString(forKey: "Lato-Regular"), size: 11.0)
            
            
            var voucherValueStyledStringsArray = [Any]()
            
            var voucherValueStyledStringsDic: [String : Any] = [:]
            voucherValueStyledStringsDic["string"] = aedString
            voucherValueStyledStringsDic["fontStyle"] = UIFont(name: LanguageManager.sharedInstance().getLocalizedString(forKey: "NeoTechAlt"), size: 10.0)
            
            if model.isSelectedVoucher{
                voucherTitleLabel.textColor = UIColor.appRedColor
                redeemUsingTitleLabel.textColor = UIColor.appRedColor
                voucherValueLabel.textColor = UIColor.appRedColor
                redeemPointsLabel.textColor = UIColor.appRedColor
                redeemCostLabel.textColor = UIColor.appRedColor
                
                orStyledStringDic["color"] = UIColor.appRedColor
                aedStyledStringDic["color"] = UIColor.appRedColor
                
                redeemCostStyledStringsArray.append(orStyledStringDic)
                redeemCostStyledStringsArray.append(aedStyledStringDic)
                
                CommonMethods.updateLabelTextStyle(redeemCostLabel, strings: redeemCostStyledStringsArray as? NSMutableArray)
                
                //Styled for redeem Points label
                
                redeemPointsStyledStringDic["color"] = UIColor.appRedColor
                redeemPointsStyledStringsArray.append(redeemPointsStyledStringDic)
                CommonMethods.updateLabelTextStyle(redeemPointsLabel, strings: redeemPointsStyledStringsArray as? NSMutableArray)
                
                
                //Styled for vocuher value label
                
                voucherValueStyledStringsDic["color"] = UIColor.appRedColor
                voucherValueStyledStringsArray.append(voucherValueStyledStringsDic)
                CommonMethods.updateLabelTextStyle(voucherValueLabel, strings: voucherValueStyledStringsArray as? NSMutableArray)
            }else{
                voucherTitleLabel.textColor = UIColor.appBlackColor
                redeemUsingTitleLabel.textColor = UIColor.appBlackColor
                voucherValueLabel.textColor = UIColor.appBlackColor
                redeemPointsLabel.textColor = UIColor.appBlackColor
                redeemCostLabel.textColor = UIColor.appBlackColor


                orStyledStringDic["color"] = UIColor.appGreyColor_128
                aedStyledStringDic["color"] = UIColor.appGreyColor_128

                redeemCostStyledStringsArray.append(orStyledStringDic)
                redeemCostStyledStringsArray.append(aedStyledStringDic)

                CommonMethods.updateLabelTextStyle(redeemCostLabel, strings: redeemCostStyledStringsArray as? NSMutableArray)

                //Styled for redeem Points label

                redeemPointsStyledStringDic["color"] = UIColor.appGreyColor_128
                redeemPointsStyledStringsArray.append(redeemPointsStyledStringDic)
                CommonMethods.updateLabelTextStyle(redeemPointsLabel, strings: redeemPointsStyledStringsArray as? NSMutableArray)



                //Styled for vocuher value label

                voucherValueStyledStringsDic["color"] = UIColor.appGreyColor_128
                voucherValueStyledStringsArray.append(voucherValueStyledStringsDic)
                CommonMethods.updateLabelTextStyle(voucherValueLabel, strings: voucherValueStyledStringsArray as? NSMutableArray)
                
            }
        }
    }
}
