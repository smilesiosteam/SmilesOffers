//
//  DiscoubntAndDetailsPriceTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/11/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

class DiscountAndDetailsPriceTableViewCellModel {
    
    var title: String = ""
    var price: String = ""
    var isDealVoucherType = false
    var dirhamValue : Double?
    var pointValue : Int?
    var lifestyleSubscriberFlag = false
    var priceWithDirhamValue = false
    var excludingVAT: String?
}

class DiscountAndDetailsPriceTableViewCell: SuperTableViewCell {
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var excludingVATLabel: UILabel!

    var selectedModel = DiscountAndDetailsPriceTableViewCellModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    class func rowModel(value: DiscountAndDetailsPriceTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsPriceTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? DiscountAndDetailsPriceTableViewCellModel {
            selectedModel = model
            priceTitleLabel.text = model.title
            priceLabel.text = model.price
            
            if model.lifestyleSubscriberFlag{
                if let dirham = model.dirhamValue, let point = model.pointValue {
                    populateCellIfLifeStyleSubscriber(withPrices: dirham, point: point)
                }
            }else if model.priceWithDirhamValue{
                if let dirham = model.dirhamValue, let point = model.pointValue {
                populateCellWithPrices(withPrices: dirham, point: point)
                }
            }
            
            if let excludingVATDescription = model.excludingVAT, !excludingVATDescription.isEmpty {
                excludingVATLabel.text = excludingVATDescription
                excludingVATLabel.isHidden = false
            } else {
                if !model.lifestyleSubscriberFlag {
                    excludingVATLabel.isHidden = true
                }
            }
        }
    }
    
    func populateCellIfLifeStyleSubscriber(withPrices price: Double, point: Int) {
        if price > 0 && point > 0 {
            excludingVATLabel.textColor = UIColor.appGreyColor_128
            priceLabel.textColor = UIColor.appDarkGrayColor
            priceLabel.font = UIFont(name: "NeoTechAlt-Medium".localizedString, size: 14.0)

            let pointsValue = String(format: "%d %@", point, "Points_short".localizedString)

            let offerOriginalPrice = String(format: "%@ %@ %.0f %@", pointsValue, "OrTitle".localizedString.lowercased(), price, "AED".localizedString)

            var pointsCostStyledStringsArray: [Any] = []
            var pointsValueStringDic: [String : Any] = [:]

            pointsValueStringDic["string"] = "OrTitle".localizedString.lowercased()
            
            pointsValueStringDic["color"] = UIColor(red: 132.0 / 255.0, green: 135.0 / 255.0, blue: 137.0 / 255.0, alpha: 1)
            pointsValueStringDic["fontStyle"] = UIFont(name: "NeoTechAlt".localizedString, size: 12.0)
            
            priceLabel.isHidden = false

            pointsCostStyledStringsArray.append(pointsValueStringDic)
            excludingVATLabel.isHidden = false
            priceLabel.text = "Free".localizedString.capitalizingFirstLetter()
//            excludingVATLabel.attributedText = NSAttributedString(string: offerOriginalPrice, attributes: [
//                NSAttributedString.Key.strikethroughStyle: NSNumber(value: 1)
//            ])
//            CommonMethods.strikeLabelTextStyle(excludingVATLabel, strings: pointsCostStyledStringsArray as? NSMutableArray, string: offerOriginalPrice)
            excludingVATLabel.attributedText = NSAttributedString(string: offerOriginalPrice, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSNumber(value: 1),
                NSAttributedString.Key.foregroundColor: UIColor.appGreyColor_128
            ])
        } else {
            priceLabel.isHidden = false
            priceLabel.text = "Free".localizedString.capitalizingFirstLetter()
        }
    }
    
    func populateCellWithPrices(withPrices price: Double, point: Int) {
        if point > 0 && price > 0 {

            let ptsString = "Points_short".localizedString
            let aedString = "AED".localizedString
            let orString = "OrTitle".localizedString.lowercased()

            var costStyledStringsArray: [Any] = []

            var orStyledStringDic: [String : Any] = [:]
            orStyledStringDic["string"] = "OrTitle".localizedString
            orStyledStringDic["fontStyle"] = UIFont(name: "Lato-Regular".localizedString, size: 16.0)

            orStyledStringDic["color"] = UIColor(red: 53.0 / 255.0, green: 55.0 / 255.0, blue: 56.0 / 255.0, alpha: 1)


            var aedStyledStringDic: [String : Any] = [:]
            aedStyledStringDic["string"] = "AED".localizedString
            aedStyledStringDic["fontStyle"] = UIFont(name: "Lato-Regular".localizedString, size: 16.0)

            if selectedModel.isDealVoucherType {
                aedStyledStringDic["color"] = UIColor(red: 0.89, green: 0.48, blue: 0.24, alpha: 1)
                orStyledStringDic["color"] = UIColor(red: 0.89, green: 0.48, blue: 0.24, alpha: 1)
            } else {
                aedStyledStringDic["color"] = UIColor(red: 53.0 / 255.0, green: 55.0 / 255.0, blue: 56.0 / 255.0, alpha: 1)
            }

            var ptsStyledStringDic: [String : Any] = [:]
            ptsStyledStringDic["string"] = "Points_short".localizedString
            ptsStyledStringDic["fontStyle"] = UIFont(name: "Lato-Regular".localizedString, size: 16.0)

            if selectedModel.isDealVoucherType {
                ptsStyledStringDic["color"] = UIColor(red: 0.89, green: 0.48, blue: 0.24, alpha: 1)
            } else {
                ptsStyledStringDic["color"] = UIColor(red: 53.0 / 255.0, green: 55.0 / 255.0, blue: 56.0 / 255.0, alpha: 1)
            }
            costStyledStringsArray.append(orStyledStringDic)
            costStyledStringsArray.append(aedStyledStringDic)
            costStyledStringsArray.append(ptsStyledStringDic)
            
            let pointString = CommonMethods.numberFormatterDecimalStyle(point) ?? "0"
            let dirhamString = "\(price)"
            
            let pointValue = String(format:"%@ %@",pointString,ptsString)
            let dirhamValue = String(format:"%@ %@",dirhamString,aedString)


            let priceString = "\(pointValue)  \(orString)  \(dirhamValue)"

            priceLabel.text = priceString

            if selectedModel.isDealVoucherType {
                priceLabel.textColor = UIColor(red: 0.89, green: 0.48, blue: 0.24, alpha: 1)
            }


            CommonMethods.updateLabelTextStyle(priceLabel, strings: costStyledStringsArray as? NSMutableArray)
        }
    }
}
