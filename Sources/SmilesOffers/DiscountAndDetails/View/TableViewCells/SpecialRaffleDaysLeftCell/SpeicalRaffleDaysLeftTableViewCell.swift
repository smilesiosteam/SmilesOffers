//
//  SpeicalRaffleDaysLeftTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/14/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

protocol SpeicalRaffleDaysLeftTableViewCellDelegate {
    func isExpiredDeal(expire:Bool)
}


class SpeicalRaffleDaysLeftTableViewCellModel{
    var delegate : SpeicalRaffleDaysLeftTableViewCellDelegate?
    var luckyDealExpiryDate : String = ""
}

class SpeicalRaffleDaysLeftTableViewCell: SuperTableViewCell, MZTimerLabelDelegate, CountdownLabelDelegate {
    @IBOutlet weak var dealEndsTitleLbl: UILabel!
    @IBOutlet weak var dealTimerLbl: CountdownLabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dealHourMinLbl: UILabel!
    
    var delegate : SpeicalRaffleDaysLeftTableViewCellDelegate?
    var selectedModel : SpeicalRaffleDaysLeftTableViewCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = UIColor().colorWithHexString(hexString: "EC8A23")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //TODO: replace string with model
    class func rowModel(value : SpeicalRaffleDaysLeftTableViewCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "SpeicalRaffleDaysLeftTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        return rowModel
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? SpeicalRaffleDaysLeftTableViewCellModel{
            selectedModel = model
            
            if SmilesLanguageManager.shared.currentLanguage == .en {
                dealHourMinLbl.text = "Hours".localizedString + "   \t " + "MinTitle".localizedString.uppercased() + "\t\t" + "Secs".localizedString
                dealEndsTitleLbl.text = String(format:"%@%@","DealEndInTitle".localizedString,":")
            }else{
                dealHourMinLbl.text =  "Secs".localizedString + "   \t " + "MinTitle".localizedString.uppercased() + "\t\t" + "Hours".localizedString
                dealEndsTitleLbl.text = String(format:"%@","DealEndInTitle".localizedString)
            }
            
            
            self.setPlanTimer(on: self.dealTimerLbl, withExpiryTime: selectedModel?.luckyDealExpiryDate)
        }
    }
    
    
    func setPlanTimer(on timerLabel: CountdownLabel, withExpiryTime expiryTime: String?) {
        let dealExpireDate = CommonMethods.returnDate(from: expiryTime!, format: "yyyy-MM-dd HH:mm:ss")
        
        let dateGMT = Date()
        let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
        let correctDate = dateGMT.addingTimeInterval(TimeInterval(secondsFromGMT))
        
        
        if dealExpireDate?.compare(correctDate) == .orderedDescending || dealExpireDate?.compare(correctDate) == .orderedSame {
            
            if let timeString = expiryTime, let time = AppCommonMethods.getFormatedTime(expireDate: timeString) {
                timerLabel.setCountDownTime(minutes: time)
                timerLabel.timeFormat = "hh\t:\tmm\t:\tss"
                timerLabel.countdownDelegate = self
                timerLabel.start()
            }
            self.isDealExpired(false)

        }else{
            self.isDealExpired(true)

        }
       
    }
    

    func isDealExpired(_ isExpired: Bool) {
        if isExpired {
            self.dealTimerLbl.isHidden = true
            self.dealHourMinLbl.isHidden = true
            dealEndsTitleLbl.text = "DealExpiredTitle".localizedString
            dealEndsTitleLbl.textColor = UIColor.white
            containerView.backgroundColor = UIColor(red: 190.0 / 255.0, green: 18.0 / 255.0, blue: 24.0 / 255.0, alpha: 1.0)
        }
        
        if let delegate = selectedModel?.delegate{
            delegate.isExpiredDeal(expire: isExpired)
        }
    }
    
    
    func countdownFinished(){
            isDealExpired(true)
    }
}


