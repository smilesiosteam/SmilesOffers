//
//  DiscoubntAndDetailsCashVoucherTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/14/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesLanguageManager
import SmilesUtilities

protocol VoucherAmountCellModelDelegate: AnyObject {
    func textFieldDidChange(updatedValue: String?, valueChangeOn cell: DiscountAndDetailsCashVoucherTableViewCell?)
    func forTextFieldDidBeginEditing()
}

class VoucherAmountCellModel {
    var baseRowModels: [BaseRowModel]? = []
    var cashVoucherDescription : String?
    var voucherAmount : String?
    var selectedIndex = 0
    var errorText: String?
    var textFieldPlaceholder: String?
    var textFieldInteraction = true
    var collectionViewInteraction = true
    var errorColor: UIColor?
    
    init() {
    }
}

class DiscountAndDetailsCashVoucherTableViewCell: SuperTableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var voucherAmountText: BaseLabel!
    @IBOutlet weak var voucherAmountView: UIView! {
        didSet {
            voucherAmountView.layer.cornerRadius = 12.0
        }
    }
    @IBOutlet weak var amountCollectionView: UICollectionView!
    @IBOutlet weak var voucherDescriptionLbl: UILabel!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Properties
    
    var baseDataSource  : BaseCollectionViewDataSource!
    weak var delegate: VoucherAmountCellModelDelegate?
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        super.updateCell(rowModel: rowModel)
        //populate Cell here...
        if let model = rowModel.rowValue as? VoucherAmountCellModel {
            self.delegate = rowModel.delegate as? VoucherAmountCellModelDelegate
            
            if let placeholder = model.textFieldPlaceholder, !placeholder.isEmpty {
                self.voucherAmountText.text = placeholder
            }
            
            self.voucherDescriptionLbl.text = model.cashVoucherDescription.asStringOrEmpty()
            self.amountText.text = model.voucherAmount.asStringOrEmpty()
            
            self.errorLabel.textColor = model.errorColor
            
            amountText.textAlignment = .left
            
            if let error = model.errorText, !error.isEmpty {
                self.errorLabel.text = error
            }
            
            amountText.isUserInteractionEnabled = model.textFieldInteraction
            
            if model.collectionViewInteraction {
                amountCollectionView.isUserInteractionEnabled = true
                amountCollectionView.alpha = 1.0
            } else {
                amountCollectionView.isUserInteractionEnabled = false
                amountCollectionView.alpha = 0.4
            }
            
            if SmilesLanguageManager.shared.currentLanguage == .ar {
                amountText.textAlignment = .right
            }
            
            if let models = model.baseRowModels, !models.isEmpty {
                setUpAmountDataSource(amountModel: models, dataSourceDelegate: rowModel.delegate as? BaseDataSourceDelegate)
            }
        }
    }
    
    // MARK: - Methods
    
    func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.amountCollectionView.collectionViewLayout = flowLayout
        
        amountCollectionView.register(UINib(nibName: String(describing: DenominationAmountCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DenominationAmountCell.self))
        
        amountText.delegate = self
    }
    
    func setUpAmountDataSource(amountModel: [BaseRowModel], dataSourceDelegate: BaseDataSourceDelegate?) {
        baseDataSource = BaseCollectionViewDataSource(dataSource: amountModel, delegate: dataSourceDelegate)
        
        amountCollectionView.dataSource = baseDataSource
        amountCollectionView.delegate = baseDataSource
        amountCollectionView.reloadData()
    }
    
    //TODO: replace string with model
    class func rowModel(model:VoucherAmountCellModel, delegate: BaseDataSourceDelegate?) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsCashVoucherTableViewCell"
        rowModel.rowValue = model
        rowModel.delegate = delegate
        return rowModel
    }
}


extension DiscountAndDetailsCashVoucherTableViewCell: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji{
            return false
        }
        
        guard let oldText = self.amountText.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //case for Amount field
        if let text = self.amountText.text, !text.isEmpty{
            //            errorLabel.text = ""
        }
        else{
            //            errorLabel.text = "EmptyField".localizedString
        }
        
        if let delegate = self.delegate {
            
            var billAmountIdentifier = "%.f"
            if textField.text?.toDouble() ?? 0.0 > 0 {
                billAmountIdentifier = "%.2f"
            }
            
            self.amountText.text = String(format: "\(billAmountIdentifier)", textField.text?.toDouble() ?? 0.0)
            delegate.textFieldDidChange(updatedValue: textField.text, valueChangeOn: self)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        errorLabel.text = ""
        textField.text = ""
        delegate?.forTextFieldDidBeginEditing()
    }
}
