//
//  DiscountAndDetailsRelatedOffersTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/16/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class DiscountAndDetailsRelatedOffersTableViewCell: SuperTableViewCell {

    @IBOutlet weak var otherOffersTitle: BaseLabel! {
        didSet {
            otherOffersTitle.text = "OtherOffersTitle".localizedString.capitalized
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var dealsForYouDataSource : BaseCollectionViewDataSource!
    var flowLayout = UICollectionViewFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCollectionView() {
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func setUpRelatedOffersDataSource(offers: [BaseRowModel], dataSourceDelegate: BaseDataSourceDelegate?)  {
        
        dealsForYouDataSource = BaseCollectionViewDataSource(dataSource: offers, delegate: dataSourceDelegate)
        collectionView.dataSource = dealsForYouDataSource
        collectionView.delegate = dealsForYouDataSource
        collectionView.reloadData()
    }
    
    override func setupStyles() {
        collectionView.register(UINib(nibName: String(describing: OffersCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: OffersCollectionViewCell.self))
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let offers = rowModel.rowValue as? [OffersList] {
            var collectionItems: [BaseRowModel] = []
            
            collectionView.tag = rowModel.tag
            
            for item in offers {
                if rowModel.isSelected{
                    item.isWishlisted = true
                }
                collectionItems.append(OffersCollectionViewCell.rowModel(model: item, delegate: rowModel.delegate, tag: rowModel.tag, rowWidth: (((UIApplication.shared.delegate as? AppDelegate)?.window.frame.width ?? self.bounds.width) / 2) - 24))
            }
            
            if let direction = rowModel.direction {
                flowLayout.scrollDirection = direction
                self.collectionView.collectionViewLayout = flowLayout
            }

            self.setUpRelatedOffersDataSource(offers: collectionItems, dataSourceDelegate: rowModel.delegate as? BaseDataSourceDelegate)
            
        }
    }
    
    class func rowModel(model: [OffersList]?, delegate: BaseDataSourceDelegate?, tag: Int, isFavorite: Bool? = false, rowHeight: CGFloat = UITableView.automaticDimension, scrollDirection:UICollectionView.ScrollDirection? = .vertical) -> BaseRowModel {
        
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsRelatedOffersTableViewCell"
        rowModel.rowHeight = 360
        rowModel.rowValue = model
        rowModel.delegate = delegate
        rowModel.tag = tag
        rowModel.direction = scrollDirection
        rowModel.isSelected = isFavorite.asBoolOrFalse()
        return rowModel
    }
}
