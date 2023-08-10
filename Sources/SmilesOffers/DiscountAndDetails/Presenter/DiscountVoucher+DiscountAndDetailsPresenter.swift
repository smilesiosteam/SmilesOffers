//
//  DiscountVoucherPresenter.swift
//  House
//
//  Created by Faraz Haider on 14/11/2021.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities

/*Discount Voucher*/
extension DiscountAndDetailsPresenter{
    
    func checkIfLuckyDealExpired(_ date: String?) {
        if isFromGamification {
            //            btn_share.hidden = true
            //            btn_favorite.hidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            var dateFromString = Date()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            if let date1 = dateFormatter.date(from: date ?? "") {
                dateFromString = date1
            }
            
            view?.luckyDeal()
            
            //            view?.enableGetNowButton(false)
            view?.enableContinueButton(false)
            let dateGMT = Date()
            let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
            let correctDate = dateGMT.addingTimeInterval(TimeInterval(secondsFromGMT))
            
            
            if dateFromString.compare(correctDate) == .orderedDescending || dateFromString.compare(correctDate) == .orderedSame {
                view?.enableContinueButton(true)
            }
            
            let dealsViewController = SuperDealsViewController()
            dealsViewController.isFromGamification = true
            
            if let offer = offersDetailResponse{
                dealsViewController.registerEvent(forGamification: "true", isPurchase: "false", itemId: offer.offerId, partnerName: offer.partnerName, categoryId: String(format: "%d", offer.categoryId ?? 0))
            }
        }
    }
    
    func checkIfSoldOutOrWeeklyLimit(offerType: OfferType) {
        if let offersResponse = offersDetailResponse {
            if ((offersResponse.eligibleFlag == SOLD_OUT) || (offersResponse.eligibleFlag == SOLD_OUT_PREPAID_USER) || (offersResponse.eligibleFlag == SOLD_OUT_LIMIT1) || (offersResponse.eligibleFlag == SOLD_OUT_LIMIT2) || (offersResponse.eligibleFlag == SOLD_OUT_LIMIT3)){
                isSoldOut = true
                isWeeklyLimit = false
            } else if (offersResponse.eligibleFlag == ELIGABLE){
                checkIfLuckyDealExpired(luckyDealExpiryDate)
                isWeeklyLimit = false
                isSoldOut = false
            } else{
                isWeeklyLimit = true
                isSoldOut = false
            }
        }
    }
    
    func createRowsForDiscountOffer() {
        if let offersResponse = offersDetailResponse {
            
            if (!(offersResponse.isBirthdayOffer ?? true) && !(offersResponse.isRedeemedOffer ?? true)) {
                if (isSoldOut){
                    self.sectionItems.append(rowModelForSoldOut())
                    self.view?.dealSoldOut(isSoldOut: true)
                } else{
                    if luckyDealExpiryDate.count > 0 {
                        self.sectionItems.append(rowModelForSpeicalRaffleDaysLeft())
                    }
                }
            } else if (offersResponse.isRedeemedOffer ?? false){
                self.sectionItems.append(rowModelForRedeemedOffer())
            }
            
            
            if !(offersResponse.isRedeemedOffer ?? true) {
                if (offersResponse.pointsValue == 0 && offersResponse.dirhamValue == 0) {
                    self.sectionItems.append(rowModelForFreePrice(price: "Free".localizedString.capitalizingFirstLetter(), title: !self.isFromGamification ? "PriceTitle".localizedString.capitalizingFirstLetter() : "GetItTitle".localizedString.capitalizingEveryFirstLetter()))
                    if isSoldOut {
                        self.view?.enableContinueButton(false)
                    } else {
                        self.view?.enableContinueButton(true)
                    }
                } else {
                    if offersResponse.offerType != .discount || !(offersResponse.childOffers ?? []).isEmpty {
                        if offersDetailResponse?.offerType == .etisalat {
                            if let getUserProfileResponse = getUserProfileResponse.sharedClient().onAppStartObjectResponse, let isVatable = getUserProfileResponse.isVatable , isVatable.lowercased() == .trueValue {
                                var vatPercentage = getUserProfileResponse.vatPercentage ?? ""
                                vatPercentage = vatPercentage + "%"
                                self.sectionItems.append(rowModelForPrice(price: "Free".localizedString.capitalizingFirstLetter(), title: !self.isFromGamification ? "PriceTitle".localizedString.capitalizingFirstLetter() : "GetItTitle".localizedString.capitalizingEveryFirstLetter(), vatExcludedDescription: String(format: "VatExcludedTitle".localizedString, vatPercentage)))
                            } else {
                                self.sectionItems.append(rowModelForPrice(price: "Free".localizedString.capitalizingFirstLetter(), title: !self.isFromGamification ? "PriceTitle".localizedString.capitalizingFirstLetter() : "GetItTitle".localizedString.capitalizingEveryFirstLetter(), vatExcludedDescription: ""))
                            }
                        } else {
                            self.sectionItems.append(rowModelForPrice(price: "Free".localizedString.capitalizingFirstLetter(), title: !self.isFromGamification ? "PriceStartsTitle".localizedString.capitalizingFirstLetter() : "GetItTitle".localizedString.capitalizingEveryFirstLetter(), vatExcludedDescription: ""))
                        }
                    }else{
                        self.sectionItems.append(rowModelForPrice(price: "Free".localizedString.capitalizingFirstLetter(), title: !self.isFromGamification ? "PriceTitle".localizedString.capitalizingFirstLetter() : "GetItTitle".localizedString.capitalizingEveryFirstLetter(), vatExcludedDescription: ""))
                    }
                }
            } else if(offersResponse.isBirthdayOffer ?? false && !(offersResponse.isRedeemedOffer ?? true)) {
                self.sectionItems.append(rowModelForBirthdayBanner())
            }
        }
    }
    
    
    func rowModelForSoldOut() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let model = DiscountAndDetailsSoldOutTableViewCellModel()
        model.title = offersDetailResponse?.ineligibleTitle ?? ""
        model.subTitle = offersDetailResponse?.ineligibleMsg ?? ""
        let soldOutCell = DiscountAndDetailsSoldOutTableViewCell.rowModel(value:model)
        rowSectionModels.rowItems.append(soldOutCell)
        
        return rowSectionModels
    }
    
    
    func rowModelForSpeicalRaffleDaysLeft() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let model = SpeicalRaffleDaysLeftTableViewCellModel()
        model.luckyDealExpiryDate = luckyDealExpiryDate
        model.delegate = self
        let raffleCell = SpeicalRaffleDaysLeftTableViewCell.rowModel(value:model)
        rowSectionModels.rowItems.append(raffleCell)
        
        return rowSectionModels
    }
    
    
    func rowModelForRedeemedOffer() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let model = DiscountAndDetailsRedeemedOfferTableViewCellModel()
        if self.birthDayRedeemedTitle.count > 0 {
            model.title = self.birthDayTitle
        }else {
            model.title = "REDEEMED_CAP".localizedString
        }
        
        let redeemCell = DiscountAndDetailsRedeemedOfferTableViewCell.rowModel(value: model)
        rowSectionModels.rowItems.append(redeemCell)
        
        return rowSectionModels
    }
    
    func rowModelForFreePrice(price:String, title: String) -> BaseSectionModel {
        
        let rowSectionModels = BaseSectionModel()
        let model = DiscountAndDetailsPriceTableViewCellModel()
        model.isDealVoucherType = false
        model.price = price
        model.title = title
        model.lifestyleSubscriberFlag = offersDetailResponse?.lifestyleSubscriberFlag ?? false
        model.pointValue = offersDetailResponse?.originalPointsValue
        model.dirhamValue = offersDetailResponse?.originalDirhamValue
        
        let cell = DiscountAndDetailsPriceTableViewCell.rowModel(value: model)
        rowSectionModels.rowItems.append(cell)
        
        return rowSectionModels
    }
    
    
    func rowModelForPrice(price:String, title: String, vatExcludedDescription: String) -> BaseSectionModel {
        
        let rowSectionModels = BaseSectionModel()
        let model = DiscountAndDetailsPriceTableViewCellModel()
        model.isDealVoucherType = false
        model.price = price
        model.title = title
        model.pointValue = offersDetailResponse?.pointsValue
        model.dirhamValue = offersDetailResponse?.dirhamValue
        model.priceWithDirhamValue = true
        model.excludingVAT = vatExcludedDescription
        
        let cell = DiscountAndDetailsPriceTableViewCell.rowModel(value: model)
        rowSectionModels.rowItems.append(cell)
        
        return rowSectionModels
    }
    
    
    func rowModelForBirthdayBanner() -> BaseSectionModel{
        
        let rowSectionModels = BaseSectionModel()
        let model = BirthdayPriceBannerTableViewCellModel()
        
        if !(self.birthDayTitle == ""){
            model.title =  self.birthDayTitle
        }
        else{
            model.title = "BirthdayGift".localizedString
        }
        
        let cell = BirthdayPriceBannerTableViewCell.rowModel(value: model)
        rowSectionModels.rowItems.append(cell)
        
        return rowSectionModels
    }
    
    func rowModelForOfferPromotional() -> BaseSectionModel{
        let rowSectionModels = BaseSectionModel()
        let model = DiscountAndDetailsRamdanOfferTableViewCellModel()
        model.title = offersDetailResponse?.offerPromotionText ?? ""
        
        let cell = DiscountAndDetailsRamdanOfferTableViewCell.rowModel(value: model)
        rowSectionModels.rowItems.append(cell)
        
        return rowSectionModels
    }
    
    
    
}

// MARK- SpeicalRaffleDaysLeftTableViewCellDelegate
extension DiscountAndDetailsPresenter: SpeicalRaffleDaysLeftTableViewCellDelegate{
    
    func isExpiredDeal(expire: Bool) {
        //disable button
        self.view?.dealExpired(isExpired: expire)
        self.view?.enableContinueButton(!expire)
    }
}




