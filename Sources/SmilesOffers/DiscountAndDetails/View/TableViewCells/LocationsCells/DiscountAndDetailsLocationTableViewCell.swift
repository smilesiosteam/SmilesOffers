//
//  DiscountAndDetailsLocationTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/25/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager


protocol DiscountAndDetailsLocationCellDelegate: AnyObject {
    func didSelectContact(selectedIndex: Int)
    func didSelectMap(selectedIndex: Int)
}

class DiscountAndDetailsLocationTableModel {
    var locationName: String?
    var locationAddress: String?
    var locationLatitude: Double?
    var locationLongitude: Double?
    var distance: Double?
    var locationPhoneNumber: String?
    var rowValue: BaseRowModel?
    init() {}
}


class DiscountAndDetailsLocationTableViewCell: SuperTableViewCell {
    
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var locationAddressLbl: UILabel!
    @IBOutlet weak var locationDistanceLbl: UILabel!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var locationView: UIView!
    
    var delegate: DiscountAndDetailsLocationCellDelegate?
    var selectedObject: DiscountAndDetailsLocationTableModel?
    
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
        
        locationView.isHidden = true
        callView.isHidden = true
        locationDistanceLbl.isHidden = true
        
        if let model = rowModel.rowValue as? DiscountAndDetailsLocationTableModel {
            self.delegate = rowModel.delegate as? DiscountAndDetailsLocationCellDelegate
            
            self.locationNameLbl.text = model.locationName.asStringOrEmpty()
            self.locationAddressLbl.text = model.locationAddress.asStringOrEmpty()
            
            if let latitude = model.locationLatitude, latitude > 0, let longitude = model.locationLongitude, longitude > 0{
                locationView.isHidden = false
            }
            
            if let phoneNumber = model.locationPhoneNumber, phoneNumber.count > 0, !phoneNumber.isEmpty {
                callView.isHidden = false
            }
            
            if let distance = model.distance{
                locationDistanceLbl.isHidden = false
                
                var distanceCheck: Double = distance
                if (distanceCheck >= 1000) {
                    distanceCheck /= 1000
                    distanceCheck = floor(distanceCheck)
                    
                    let restaurantDistance = "\(distanceCheck)" + " " + "KiloMeter".localizedString
                    
                    if AppCommonMethods.languageIsArabic(){
                        locationDistanceLbl.text =  "away".localizedString + " " + restaurantDistance
                    }
                    else{
                        locationDistanceLbl.text = restaurantDistance + " " + "away".localizedString
                        
                    }
                }else{
                    let restaurantDistance = String(format: "%.2f", distance) + " " + "meter".localizedString
                    if AppCommonMethods.languageIsArabic(){
                        locationDistanceLbl.text =  "away".localizedString + " " + restaurantDistance
                    }
                    else{
                        locationDistanceLbl.text = restaurantDistance + " " + "away".localizedString
                        
                    }
                }
                
            }
        }
    }
    
    //MARK: Contact Button Action
    
    @IBAction func didTappedContact(_ sender: UIButton) {
        
        var superview = sender.superview
        while let view = superview, !(view is DiscountAndDetailsLocationTableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? DiscountAndDetailsLocationTableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView?.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        print("button is in row \(indexPath.row)")
        
        if delegate != nil {
            delegate?.didSelectContact(selectedIndex: indexPath.row - 1)
        }
    }
    
    //MARK: Map Button Action
    
    @IBAction func didTappedMap(_ sender: UIButton) {
        
        var superview = sender.superview
        while let view = superview, !(view is DiscountAndDetailsLocationTableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? DiscountAndDetailsLocationTableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView?.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        print("button is in row \(indexPath.row)")
        if delegate != nil {
            delegate?.didSelectMap(selectedIndex: indexPath.row - 1)
        }
    }
    
    //MARK: Row model
    
    //TODO: replace string with model
    class func rowModel(model: DiscountAndDetailsLocationTableModel,delegate: DiscountAndDetailsLocationCellDelegate) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsLocationTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = model
        rowModel.delegate = delegate
        return rowModel
    }
    
}
