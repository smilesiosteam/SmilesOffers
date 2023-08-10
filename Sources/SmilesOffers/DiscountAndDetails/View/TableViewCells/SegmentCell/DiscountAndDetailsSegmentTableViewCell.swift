//
//  DiscoubntAndDetailsLocationListViewCustomTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/24/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

protocol DiscountAndDetailsSegmentTableViewCellDelegate: AnyObject {
    func discountCell(_ cell: DiscountAndDetailsSegmentTableViewCell, didChange segment: HMSegmentedControl)
    func discountAndDetailsSegmentMapButtonClicked(_ cell: DiscountAndDetailsSegmentTableViewCell)
    func discountAndDetailsSegmentListButtonClicked(_ cell: DiscountAndDetailsSegmentTableViewCell)
}

//class DiscountAndDetailsSegmentTableViewCellModel{
//    var selectedIndex = 0
//    var isMapViewButtonSelected = false
//}

class DiscountAndDetailsSegmentTableViewCell: SuperTableViewCell {
    
    @IBOutlet weak var locationView: UIView!
    var segementControlCategory = HMSegmentedControl()
    @IBOutlet weak var segmentParentView: UIView!
    @IBOutlet weak var mapviewTitleLabel: UILabel!
    @IBOutlet weak var mapviewImageView: UIImageView!
    @IBOutlet weak var listviewTitleLabel: UILabel!
    @IBOutlet weak var listviewImageView: UIImageView!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!

    @IBOutlet weak var listViewButtonTitle: UILabel! {
        didSet {
            listViewButtonTitle.text = "ListViewTitle".localizedString.capitalizingEveryFirstLetter()
        }
    }
    @IBOutlet weak var mapViewButtonTitle: UILabel! {
        didSet {
            mapViewButtonTitle.text = "MapViewTitle".localizedString.capitalizingEveryFirstLetter()
        }
    }
    weak var delegate: DiscountAndDetailsSegmentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpSegementView()
        locationView.isHidden = true
        
        mapContainerView.RoundedViewConrner(cornerRadius: 8)
        listContainerView.RoundedViewConrner(cornerRadius: 8)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpSegementView() {
        let arr = ["DetailsTitle".localizedString.capitalizingFirstLetter(),"LocationsTitle".localizedString.capitalizingFirstLetter(), "TAndCTitle".localizedString.capitalizingEveryFirstLetter()]
        if LanguageManager.sharedInstance()?.currentLanguage == Arabic {
            let totalIndices = arr.count - 1

            var reversedNames = [String]()

            for arrayIndex in 0...totalIndices {
                reversedNames.append(arr[totalIndices - arrayIndex])
            }
            segementControlCategory = HMSegmentedControl.init(sectionTitles: reversedNames)
            segementControlCategory.selectedSegmentIndex = 2
        } else {
            segementControlCategory = HMSegmentedControl.init(sectionTitles: arr)
            segementControlCategory.selectedSegmentIndex = 0
        }
        segementControlCategory.frame = CGRect(x: 0, y: 0, width: segmentParentView.frame.size.width, height: segmentParentView.frame.size.height)
        segementControlCategory.backgroundColor = UIColor.clear
        segementControlCategory.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segementControlCategory.type = .text
        segementControlCategory.segmentWidthStyle = .fixed
        segementControlCategory.selectionStyle = .box
        segementControlCategory.selectionIndicatorLocation = .none
        segementControlCategory.isVerticalDividerEnabled = true
        segementControlCategory.selectionIndicatorBoxColor = UIColor.appPurpleColor1
        segementControlCategory.selectionIndicatorBoxLayer.cornerRadius = 12.0
        segementControlCategory.selectionIndicatorBoxOpacity = 1.0
        segementControlCategory.shouldSetHalfHeightOfBox = false
        segementControlCategory.verticalDividerColor = UIColor.thm_lightGreyTwo()
        segementControlCategory.verticalDividerWidth = 0.0
        segementControlCategory.shouldStretchSegmentsToScreenSize = true
        
        segementControlCategory.titleFormatter = { segmentedControl, title, index, selected in
            if let font = UIFont(name: LanguageManager.sharedInstance().getLocalizedString(forKey: "Montserrat-Bold"), size: 12.0) {
                let attributes = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: selected ? UIColor.white : UIColor.appPurpleColor1
                ] as [NSAttributedString.Key : Any]
                
                let segmentTitle = NSAttributedString(string:title.asStringOrEmpty(), attributes: attributes)
                return segmentTitle
            }
            return nil
        }
        
        segementControlCategory.addTarget(self, action: #selector(DiscountAndDetailsSegmentTableViewCell.segmentedControlChangedValue(sender:)), for: .valueChanged)
        
        segmentParentView.addSubview(segementControlCategory)
    }
    
    @objc func segmentedControlChangedValue(sender:HMSegmentedControl) {
        delegate?.discountCell(self, didChange: sender)
    }
    
    
    override func updateCell(rowModel: BaseRowModel) {
        self.delegate = rowModel.delegate as? DiscountAndDetailsSegmentTableViewCellDelegate
        
        if (self.segementControlCategory.selectedSegmentIndex == 0) || (self.segementControlCategory.selectedSegmentIndex == 2){
            locationView.isHidden = true
        }else{
            locationView.isHidden = false
        }
        
        setUpButtonsViewForLocation(mapviewSelected: rowModel.isSelected)
    }
    
    //TODO: replace string with model
    class func rowModel(delegate: DiscountAndDetailsSegmentTableViewCellDelegate) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsSegmentTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
    
        rowModel.delegate = delegate
        return rowModel
    }
    
    
    func setUpButtonsViewForLocation(mapviewSelected:Bool){
        
        mapContainerView.backgroundColor = mapviewSelected ? .appPurpleColor : .white
        mapviewTitleLabel.textColor = mapviewSelected ? .white : .appPurpleColor
        mapviewImageView.image = mapviewSelected ? UIImage(named: "mapPinImage") : UIImage(named: "mapSelectedPurple")
        
        listContainerView.backgroundColor = mapviewSelected ? .white : .appPurpleColor
        listviewTitleLabel.textColor = mapviewSelected ? .appPurpleColor : .white
        listviewImageView.image =  mapviewSelected ? UIImage(named: "ListSelectedPurple") :  UIImage(named: "listView_white")
    }
    
    @IBAction func mapviewButtonClicked(_ sender: Any) {
        self.delegate?.discountAndDetailsSegmentMapButtonClicked(self)
    }
    
    @IBAction func listViewButtonClicked(_ sender: Any) {
        self.delegate?.discountAndDetailsSegmentListButtonClicked(self)
    }
}
