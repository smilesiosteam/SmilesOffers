//
//  AgreeTermsCustomCell.swift
//  House
//
//  Created by Hanan on 11/24/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

protocol AgreeTermsCustomCellDelegate: AnyObject {
    func agreeToTermsAndConditionButtonAction()
    func openTermsButtonAction()
}

class AgreeTermsCustomCellModel {
    var delegate : AgreeTermsCustomCellDelegate?
    
    init(delegate: AgreeTermsCustomCellDelegate?) {
        self.delegate = delegate
    }
}

class AgreeTermsCustomCell: SuperTableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var btn_selection: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    
    //MARK: Properties
    weak var delegate: AgreeTermsCustomCellDelegate?
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupStyles() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        super.updateCell(rowModel: rowModel)
        //populate Cell here...
        if let model = rowModel.rowValue as? AgreeTermsCustomCellModel {
            self.delegate = model.delegate
            if SmilesLanguageManager.shared.currentLanguage == .ar {
                self.lbl_title.textAlignment = .right
            } else {
                self.lbl_title.textAlignment = .left
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func agreeToTermsAndConditionButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let delegate = self.delegate {
            delegate.agreeToTermsAndConditionButtonAction()
        }
    }
    
    @IBAction func openTermsButtonAction(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.openTermsButtonAction()
        }
    }
    
    //TODO: replace string with model
    class func rowModel(model:AgreeTermsCustomCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "AgreeTermsCustomCell"
        rowModel.rowHeight = 56
        rowModel.rowValue = model
        return rowModel
    }
    
}
