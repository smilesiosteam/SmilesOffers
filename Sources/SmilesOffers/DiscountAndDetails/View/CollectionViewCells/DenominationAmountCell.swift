//
//  DenominationAmountCell.swift
//  House
//
//  Created by Hanan on 11/25/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import AnalyticsSmiles
import SmilesUtilities

protocol DenominationAmountCellDelegate: AnyObject {
    func didSelectAmount(index: Int, tableCellIndex: Int, cell: DenominationAmountCell)
    func didUnSelectAmount(index: Int, tableCellIndex: Int, cell: DenominationAmountCell)
}

class DenominationAmountCell: SuperCollectionViewCell {

    // MARK: -- Outlets
    @IBOutlet weak var shadowParentView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var amountLbl: BaseLabel!
    @IBOutlet weak var currencyLbl: BaseLabel!
    @IBOutlet weak var moreLbl: UILabel! {
        didSet {
            moreLbl.text = "MoreTitle".localizedString
        }
    }

    // MARK: -- Properties

    var baseDataSource : BaseCollectionViewDataSource!
    weak var delegate: DenominationAmountCellDelegate?
    var model: AmountCollectionViewCellModel?

    // MARK: -- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85,alpha: 1).cgColor
        self.cellNonSelectedState()
        self.RoundedViewConrner(cornerRadius: 12)
    }
    
    override func setupStyles() {
        amountLbl.textColor = .appDarkGrayColor
        currencyLbl.textColor = .appDarkGrayColor
    }
    
    @IBAction func onAmountTapped(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.didSelectAmount(index: self.model?.selectedIndex ?? 0, tableCellIndex: self.model?.tableCellIndex ?? 0, cell: self)
            let analyticsSmiles = AnalyticsSmiles(service: FirebaseAnalyticsService())
            analyticsSmiles.sendAnalyticTracker(trackerData: Tracker(eventType: AnalyticsEvent.firebaseEvent(.ChooseDenomination(value: model?.amount ?? "")).name, parameters: [:]))
        }
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        self.delegate = rowModel.delegate as? DenominationAmountCellDelegate
        if let model = rowModel.rowValue as? AmountCollectionViewCellModel {
            self.model = model
            self.amountLbl.text = model.amount
            let aedString =  "AED".localizedString
            self.currencyLbl.text = aedString
            
            if let shouldMoreCome = model.shouldMoreCome, shouldMoreCome {
                self.moreLbl.isHidden = !shouldMoreCome
                self.colorView.isHidden = shouldMoreCome
            } else {
                self.moreLbl.isHidden = true
                self.colorView.isHidden = false
            }
            
            if model.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.cellSelectedState()
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.cellNonSelectedState()
                }
            }
        }
    }
    
    func cellSelectedState() {
        if let shouldMoreCome = self.model?.shouldMoreCome, shouldMoreCome {
            return
        }
        self.backgroundColor = UIColor.appPurpleColor1
        self.amountLbl.textColor = .white
        self.currencyLbl.textColor = .white
        
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    
    }
    
    func cellNonSelectedState() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.appLightGrayColor2.withAlphaComponent(0.80).cgColor
        
        self.backgroundColor = .white
        self.amountLbl.textColor = .appDarkGrayColor
        self.currencyLbl.textColor = .appDarkGrayColor
        
        if let delegate = self.delegate {
            delegate.didUnSelectAmount(index: self.model?.selectedIndex ?? 0, tableCellIndex: self.model?.tableCellIndex ?? 0, cell: self)
        }
    }
    
    // MARK: - Cell Provider
    
    // __________________________________________________________________________________
    //
    
    class func rowModel(model: AmountCollectionViewCellModel?,delegate: DenominationAmountCellDelegate) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DenominationAmountCell"
        rowModel.rowWidth = 64
        rowModel.rowHeight = 60
        rowModel.delegate = delegate
        rowModel.rowValue = model
        return rowModel
    }
}
