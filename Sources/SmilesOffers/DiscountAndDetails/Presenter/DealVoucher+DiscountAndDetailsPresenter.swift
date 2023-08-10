//
//  DealVoucher+DiscountAndDetailsPresenter.swift
//  House
//
//  Created by Hanan on 11/17/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities

extension DiscountAndDetailsPresenter {
    
    func createRowsForDealsOffer() {
        if let offersResponse = offersDetailResponse {
            
            if (isSoldOut){
                self.sectionItems.append(rowModelForSoldOut())
                self.view?.dealSoldOut(isSoldOut: true)
            } else{
                if luckyDealExpiryDate.count > 0 {
                    self.sectionItems.append(rowModelForSpeicalRaffleDaysLeft())
                }
            }
            //            else if (offersResponse.isRedeemedOffer ?? false) {
            //                self.sectionItems.append(rowModelForRedeemedOffer())
            //            }
            
            
            if (offersResponse.pointsValue == 0 && offersResponse.dirhamValue == 0) {
                self.sectionItems.append(rowModelForFreePrice(price: "Free".localizedString.capitalizingEveryFirstLetter(), title: !self.isFromGamification ? "DiscountedVoucherTitle".localizedString: "GetItTitle".localizedString))
            } else{
                self.sectionItems.append(rowModelForPrice(price: "Free".localizedString.capitalizingFirstLetter(), title: !self.isFromGamification ? "DiscountedVoucherTitle".localizedString: "GetItTitle".localizedString, vatExcludedDescription:""))
            }
            //            else if(offersResponse.isBirthdayOffer ?? false && !(offersResponse.isRedeemedOffer ?? true)) {
            //                self.sectionItems.append(rowModelForBirthdayBanner())
            //            }
        }
    }
    
    func rowModelDealVoucherChildOffersQuantity(childOffers: [DealVoucherSwift]) -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        
        for (index, offer) in childOffers.enumerated() {
            let amountToAddString = "\(AppCommonMethods.getWithAEDValue(string: "\(offer.originalPrice.asDoubleOrEmpty())"))"
            
            let discountedAmountString = "\(AppCommonMethods.getWithAEDValue(string: "\(offer.discountedPrice.asDoubleOrEmpty())"))"
            let cellValue = DiscountAndDetailsOfferQuantityTableViewCellModel(cellTitle: offer.offerTitle.asStringOrEmpty(), cellDescription: offer.subtitle.asStringOrEmpty(), cellPrice: discountedAmountString, voucherQuantity: minimumQuantity, isAccountTotalLimit:offer.isAccountTotalLimit, isFree: offer.isFree(), pointsDescription: amountToAddString, delegate: self, isPriceCellExpanded: isPriceCellExpanded, strikeThroughPrice: true)
            if isSoldOut {
                cellValue.isSoldOut = true
            }
            let offerQuantityCell = DiscountAndDetailsOfferQuantityTableViewCell.rowModel(value: cellValue)
            offerQuantityCell.tag = index
            rowSectionModels.rowItems.append(offerQuantityCell)
        }
        
        return rowSectionModels
        
    }
    
    func rowModelAgreeTermsForEtisalat() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let cbdCell = AgreeTermsCustomCell.rowModel(model: AgreeTermsCustomCellModel(delegate: self))
        rowSectionModels.rowItems.append(cbdCell)
        
        return rowSectionModels
    }
    
}

// MARK: -- AgreeTermsCustomCellDelegate
extension DiscountAndDetailsPresenter: AgreeTermsCustomCellDelegate {
    func agreeToTermsAndConditionButtonAction() {
        self.termsCondtionsAccepted = !self.termsCondtionsAccepted
        
        view?.enableContinueButton(self.termsCondtionsAccepted)
    }
    
    func openTermsButtonAction() {
        let aTermsAndConditionViewController = SwiftUtli.getViewController(fromStoryboardName: "DiscountOfferDetails", andIdentifier: "TermsAndConViewController") as! TermsAndConViewController
        aTermsAndConditionViewController.termsAndConditionString = self.offersDetailResponse?.termsAndConditions ?? ""
        aTermsAndConditionViewController.isFromEtisalatDetails = true
        self.router?.navigateToViewController(viewController: aTermsAndConditionViewController)
    }
}
