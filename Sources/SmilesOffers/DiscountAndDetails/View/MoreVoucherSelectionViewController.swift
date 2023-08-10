//
//  MoreVoucherSelectionViewController.swift
//  House
//
//  Created by Faraz Haider on 25/11/2021.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

@objc protocol MoreVoucherSelectionViewControllerDelegate: AnyObject {
    @objc func didselectWith(index : Int)
}


class MoreVoucherSelectionViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = -1
    var voucherArray = [VoucherDenomination]()
    var delegate : MoreVoucherSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellFromNib(DiscountAndDetailMoreVoucherSelectionCell.self, withIdentifier: String(describing: DiscountAndDetailMoreVoucherSelectionCell.self))
        setupTableViewData()
    }
    
    
    
    func setupTableViewData(){
        var sectionItems = [BaseSectionModel]()
        
        let sectionModel = BaseSectionModel()
        let yourLinksheaderView1 = GenericHeaderView.setUpView()
        yourLinksheaderView1.setUpHeaderView(model: GenericTitleHeaderModel(title: "ChooseVoucherTitle".localizedString, subTitle: "", mode: .titleOnly))
        sectionModel.sectionView = yourLinksheaderView1
        sectionModel.sectionHeight = 49
        
        for (index,vouchers) in voucherArray.enumerated(){
            let model = DiscountAndDetailMoreVoucherSelectionCellModel()
            model.voucherDenominations = vouchers
            if ((index != -1) && index == selectedIndex){
                model.isSelectedVoucher = true
            }else{
                model.isSelectedVoucher = false
            }
            
            let cell = DiscountAndDetailMoreVoucherSelectionCell.rowModel(value:model)
            sectionModel.rowItems.append(cell)
        }
        sectionItems.append(sectionModel)
        
        self.rowModelsGeneratedForMoreVoucherSelection(withSectionsModels: sectionItems, delegate: self)
    }
    
    func rowModelsGeneratedForMoreVoucherSelection(withSectionsModels: [BaseSectionModel], delegate: MoreVoucherSelectionViewController) {
        setUpTableViewSectionsDataSource(dataSource: withSectionsModels, delegate: delegate, tableView: self.tableView)
    }
    
    override func didSelectItemInRowModel(rowModel model: BaseRowModel, rowModelValue value: Any, atIndexPath indexPath: IndexPath) {
        print(value)
        selectedIndex = indexPath.row
        self.delegate?.didselectWith(index: selectedIndex)
        dismissViewController()
        
    }
    
    @IBAction func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

