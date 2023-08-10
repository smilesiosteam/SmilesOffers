//
//  BogoCustomTableCell.swift
//  House
//
//  Created by Hanan on 11/14/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

class BogoCustomTableCellModel{
    
}

class BogoCustomTableCell: SuperTableViewCell {
    
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var img_icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupStyles() {
        
        let color = UIColor(red: 132.0/255.0, green: 132.0/255.0, blue: 132.0/255.0, alpha: 0.2)
        self.view_container.layer.borderWidth = 1
        self.view_container.layer.borderColor = color.cgColor
        self.img_arrow.transform = .identity
        
        if SmilesLanguageManager.shared.currentLanguage == .ar {
            self.img_arrow.transform = CGAffineTransform(scaleX: -1, y: 1);
        }

    }
    
    override func updateCell(rowModel: BaseRowModel) {
        let bogoTitle = getUserProfileResponse.sharedClient()?.onAppStartObjectResponse?.offersForFreeBannerTextTitle ?? ""
        let bogoSubTitleTitle = getUserProfileResponse.sharedClient()?.onAppStartObjectResponse?.offersForFreeBannerTextSubTitle ?? ""


            if (bogoTitle != "") && (bogoSubTitleTitle != "") {
                lbl_title.text = "\(bogoTitle)\n\(bogoSubTitleTitle)"

                if let font = UIFont(name: "Lato-Bold", size: 15.0) {
                    CommonMethods.updateLabelTextStyle(
                        lbl_title,
                        strings: [
                            [
                                    "string": bogoTitle,
                                    "color": UIColor.black,
                                    "fontStyle": font
                                ]
                        ])
                }
                
                
                img_icon.setImageWithUrlString(getUserProfileResponse.sharedClient()?.onAppStartObjectResponse?.offersForFreeBannerIcon ?? "", defaultImage: "Offer%")
            }
    }
    
    //TODO: replace string with model
    class func rowModel(value:BogoCustomTableCellModel) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "BogoCustomTableCell"
        rowModel.rowHeight = 95
        rowModel.rowValue = value
        
        return rowModel
    }
    
}





