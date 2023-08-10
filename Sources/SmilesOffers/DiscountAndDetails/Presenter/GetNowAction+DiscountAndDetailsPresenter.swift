//
//  GetNowAction+DiscountAndDetailsPresenter.swift
//  House
//
//  Created by Mutahir Pirzada on 22/11/2021.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesBaseMainRequestManager
import SmilesLocationHandler
import SmilesUtilities

var getNowButton:  UIButton?
var categoryName: String?

extension DiscountAndDetailsPresenter {
    
    //MARK: Get Now Button handling
    
    func didTappedOnGetNowAction(sender: UIButton)  {
        if isGuestUser {
            router?.presentGuestPopUp()
            return
        }
        getNowButton = sender
        
        if let offerType = self.offersDetailResponse?.offerType {
            switch offerType {
                
            case .discount:
                print("Discount")
                self.actionForDiscountGetNowTap()
            case .dealVoucher:
                print("dealVoucher")
                self.actionForDealVoucherGetNowTap()
            case .etisalat:
                print("etisalat")
                self.actionForEtisalatGetNowTap()
            case .voucher:
                print("voucher")
                self.actionForVoucherGetNowTap()
            }
            
            if let recommendationModelEvent = self.recommendationModelEvent, !recommendationModelEvent.isEmpty {
                if let comeFromSummaryForRecommendedOffer = self.comeFromSummaryForRecommendedOffer, comeFromSummaryForRecommendedOffer {
                    HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType, urlScheme: nil, offerId: self.offersDetailResponse?.offerId ?? "", bannerType: nil, eventName: "customer_bought_get_now", recommendationModelEvent: recommendationModelEvent)
                } else {
                    HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType, urlScheme: nil, offerId: self.offersDetailResponse?.offerId ?? "", bannerType: nil, eventName: "related_offers_get_now", recommendationModelEvent: recommendationModelEvent)
                }
            } else {
                if let recommendationModelEvent = self.recommendationModelEventOfDealsForOffer, !recommendationModelEvent.isEmpty { // Deals for you offer only from home or viewall
                    HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType, urlScheme: nil, offerId: self.offersDetailResponse?.offerId ?? "", bannerType: nil, eventName: "dfy_get_now", recommendationModelEvent: recommendationModelEvent)
                }
            }
        }
    }
    
    
    //MARK: Get Now Discount handling
    func actionForDiscountGetNowTap() {
        if self.offersDetailResponse?.eligibleFlag == ELIGABLE {

            getNowFirebaseEvent()

            if (self.offersDetailResponse?.pointsValue == 0 && self.offersDetailResponse?.dirhamValue == 0)
            {
                self.view?.enableContinueButton(false)
                initPayment(for: .discount)

            } else {
                let selectPaymentVc = SelectPaymentMethodRouter.setupModule(type: .voucher)
                selectPaymentVc.numberOFDealVoucher = "\(self.voucherQuantity.asIntOrEmpty())"
                selectPaymentVc.selectPaymentMethodType = .voucher
                selectPaymentVc.cbdDetailResponse = self.cbdDetailResponse
                selectPaymentVc.isFromBirthDaySection = self.offersDetailResponse?.isBirthdayOffer.asBoolOrFalse()
                if let selectedDealVoucher = self.selectedDealVoucher, let arrayDealVouchers = self.offersDetailResponse?.dealVouchers, !arrayDealVouchers.isEmpty {

                    selectPaymentVc.totalPointsToBePaid = self.totalPoints.asIntOrEmpty()
                    selectPaymentVc.totalAmountToBePaid = self.totalAmount.asDoubleOrEmpty()

                    self.offersDetailResponse?.dirhamValue = self.totalAmount
                    self.offersDetailResponse?.pointsValue = self.totalPoints

                    self.offersDetailResponse?.offerImageUrl = selectedDealVoucher.imageUrl
                    self.offersDetailResponse?.offerTitle = selectedDealVoucher.offerTitle
                    selectPaymentVc.originalPoints = String(format: "%.0f", selectedDealVoucher.points ?? 0)
                    selectPaymentVc.originalAED = String(format: "%.2f", selectedDealVoucher.originalPrice ?? 0.0)
                    selectPaymentVc.isSubOfferDiscount = arrayDealVouchers.count > 0 ? true : false
                } else {

                    selectPaymentVc.isSubOfferDiscount = false
                    self.offersDetailResponse?.dirhamValue =  self.totalAmount
                    self.offersDetailResponse?.pointsValue =  self.totalPoints
                    selectPaymentVc.totalPointsToBePaid = self.totalPoints.asIntOrEmpty()
                    selectPaymentVc.totalAmountToBePaid = self.totalAmount.asDoubleOrEmpty()

                    selectPaymentVc.originalPoints = String(format: "%.0f", self.totalPoints ?? 0)
                    selectPaymentVc.originalAED = String(format: "%.2f", self.originalPrice ?? 0.0)
                }
                selectPaymentVc.offersDetailResponse = self.offersDetailResponse
                selectPaymentVc.isFromGamification = self.isFromGamification
                selectPaymentVc.isFromNearbyOffersSection = self.isFromNearbyOffersSection
                selectPaymentVc.isFromDealsForYouSection = self.isFromDealsForYouSection
                selectPaymentVc.isPointsEnabled = true

                DispatchQueue.main.async {
                    self.router?.navigateToViewController(viewController: selectPaymentVc)
                }
            }
        } else {
            self.displayPrompetViewController()
        }
    }
    
    //MARK: Fire Events
    
    func getNowFirebaseEvent() {
        CommonMethods.fireEvent(withName: String(format: kGetNowOfferIdPerCategory,offersDetailResponse?.categoryId ?? 0, offersDetailResponse?.offerId ?? 0), parameters: [:])
        
        var offerNam = ""
        if let partnerName = offersDetailResponse?.partnerName, !partnerName.isEmpty {
            offerNam = partnerName
        } else {
            if let offerId = offersDetailResponse?.offerId, !offerId.isEmpty {
                offerNam = offerId
            }
        }
        
        if let etisalatBundle = self.offersDetailResponse?.offerType?.rawValue.lowercased().contains("Etisalat Bundle".lowercased()), etisalatBundle {
            
            if let dob = CommonMethods.loadCustomObject(withKey: "DOD") as? Bool, dob {
                
                CommonMethods.fireEvent(
                    withName: kGetNowEtisalatDOD,
                    parameters: [
                        "offer_id": offersDetailResponse?.offerId ?? "",
                        "offer_name": offerNam])
                
            } else {
                CommonMethods.fireEvent(
                    withName: kEtisalatOfferDetails,
                    parameters: [
                        "offer_id": offersDetailResponse?.offerId ?? "",
                        "offer_name": offerNam])
            }
        } else {
            if let dob = CommonMethods.loadCustomObject(withKey: "DOD") as? Bool, !dob {
                CommonMethods.fireEvent(
                    withName: kGetNowLifeStyle,
                    parameters: [
                        "offer_id": offersDetailResponse?.offerId ?? "",
                        "offer_name": offerNam])
            } else {
                let eventName = "\(kGetNowDiscount)\(CommonMethods.loadCustomObject(withKey: CategoryName))"
                
                CommonMethods.fireEvent(
                    withName: eventName,
                    parameters: [
                        "offer_id": offersDetailResponse?.offerId ?? "",
                        "offer_name": offerNam])
            }
        }
    }
    
    //MARK: Get Now Etisalat handling
    
    func actionForEtisalatGetNowTap() {

        if self.offersDetailResponse?.eligibleFlag == ELIGABLE && self.termsCondtionsAccepted {
            self.getNowFirebaseEvent()

            if self.offersDetailResponse?.pointsValue == 0 && self.offersDetailResponse?.dirhamValue == 0 {
                view?.enableContinueButton(false)
                self.initPayment(for: .etisalat)
            } else {
                let selectPaymentVc = SelectPaymentMethodRouter.setupModule(type: .voucher)
                selectPaymentVc.selectPaymentMethodType = .voucher
                selectPaymentVc.offersDetailResponse = self.offersDetailResponse
                
                selectPaymentVc.isFromGamification = self.isFromGamification
                selectPaymentVc.isPointsEnabled = true
                selectPaymentVc.isFromEtisalatOffersSection = self.isFromEtisalatOffersSection
                selectPaymentVc.totalAmountToBePaid = self.totalAmount.asDoubleOrEmpty()
                selectPaymentVc.totalPointsToBePaid = self.totalPoints.asIntOrEmpty()
                DispatchQueue.main.async {
                    self.router?.navigateToViewController(viewController: selectPaymentVc)
                }
                
            }
        } else {
            self.displayPrompetViewController()
        }
    }
    
    //MARK: Get Now Deal Voucher handling
    
    func actionForDealVoucherGetNowTap() {
        if self.offersDetailResponse?.eligibleFlag == ELIGABLE {
            let selectPaymentVc = SelectPaymentMethodRouter.setupModule(type: .voucher)
            selectPaymentVc.cbdDetailResponse = self.cbdDetailResponse
            if let addInfo = self.offersDetailResponse?.additionalInfo, !addInfo.isEmpty {
                selectPaymentVc.categoryName = getCategoryName(additionalInfo: addInfo)
            } else { selectPaymentVc.categoryName = "" }
            selectPaymentVc.isFromGamification = self.isFromGamification
            selectPaymentVc.offersDetailResponse = self.offersDetailResponse
            selectPaymentVc.selectPaymentMethodType = .voucher
            selectPaymentVc.totalPointsToBePaid = self.totalPoints.asIntOrEmpty()
            selectPaymentVc.totalAmountToBePaid = self.totalAmount.asDoubleOrEmpty()
            selectPaymentVc.isFromNearbyOffersSection = self.isFromNearbyOffersSection
            selectPaymentVc.isFromDealsForYouSection = self.isFromDealsForYouSection
            selectPaymentVc.selectedDealVoucher = self.selectedDealVoucher //newly added
            selectPaymentVc.numberOFDealVoucher = "\(voucherQuantity ?? 0)"

            CommonMethods.fireEvent(withName: String(format: kGetNowOfferIdPerCategory,offersDetailResponse?.categoryId ?? 0, offersDetailResponse?.offerId ?? 0), parameters: [:])
            let eventName = "\(kGetNowVoucher)\(categoryName ?? "")"
            CommonMethods.fireEvent(
                withName: eventName,
                parameters: [
                    "offer_id": offersDetailResponse?.offerId ?? "",
                    "offer_name": offersDetailResponse?.partnerName ?? ""
                ])

            DispatchQueue.main.async {
                self.router?.navigateToViewController(viewController: selectPaymentVc)
            }
        }  else {
            displayPrompetViewController()
        }
    }
    
    //MARK: Get Now  Voucher handling
    
    func actionForVoucherGetNowTap() {
        if self.offersDetailResponse?.eligibleFlag == ELIGABLE {
            let selectPaymentVc = SelectPaymentMethodRouter.setupModule(type: .voucher)
            selectPaymentVc.cbdDetailResponse = self.cbdDetailResponse
            if let addInfo = self.offersDetailResponse?.additionalInfo, !addInfo.isEmpty {
                selectPaymentVc.categoryName = getCategoryName(additionalInfo: addInfo)
            } else { selectPaymentVc.categoryName = "" }
            selectPaymentVc.isFromGamification = self.isFromGamification
            selectPaymentVc.offersDetailResponse = self.offersDetailResponse
            selectPaymentVc.selectPaymentMethodType = .voucher
            selectPaymentVc.totalPointsToBePaid = totalPoints.asIntOrEmpty()
            selectPaymentVc.isFromNearbyOffersSection = self.isFromNearbyOffersSection
            selectPaymentVc.isFromDealsForYouSection = self.isFromDealsForYouSection
            if let voucher = selectedVoucherDomination, self.isSelectedAmountFromList {
                selectPaymentVc.totalAmountToBePaid = Double(voucher.denominationAED ?? 00)

                selectPaymentVc.offersDetailResponse?.pointsValue = voucher.denominationPoint
                selectPaymentVc.offersDetailResponse?.dirhamValue = Double(voucher.denominationAED ?? 00)
                selectPaymentVc.selectedDynamicVoucherAmount = ""

                DispatchQueue.main.async {
                    self.router?.navigateToViewController(viewController: selectPaymentVc)
                }
            } else {
                selectPaymentVc.totalAmountToBePaid = self.dynamicVoucherAmount?.toDouble() ?? 00

                selectPaymentVc.selectedDynamicVoucherAmount = self.dynamicVoucherAmount ?? ""
                selectPaymentVc.offersDetailResponse?.dirhamValue = self.dynamicVoucherAmount?.toDouble()
                selectPaymentVc.offersDetailResponse?.pointsValue = self.totalPoints
                if self.dynamicVoucherAmount?.toDouble() ?? 0 > 0 {
                    DispatchQueue.main.async {
                        self.router?.navigateToViewController(viewController: selectPaymentVc)
                    }
                } else {
                    CommonMethods.showPopUp(withTitle: "", andDescreption: "EnterVoucherAmountAED".localizedString, okButtons: true, andCancelButton: false)
                }
            }
        } else {
            displayPrompetViewController()
        }
    }
    
    //MARK: Get Category Name
    
    func getCategoryName(additionalInfo: [BaseMainResponseAdditionalInfo]) -> String {
        for info in additionalInfo {
            categoryName = info.value.asStringOrEmpty().lowercased()
        }
        
        CommonMethods.saveCustomObject(categoryName, forKey: CategoryName)
        
        return categoryName ?? ""
    }
    
    //MARK: Prompet View Controller
    
    func displayPrompetViewController () {
        
        view?.enableContinueButton(false)
        let prompetPopUpViewController = CommonMethods.getViewController(fromStoryboardName: "Home_new", andIdentifier: "PrompetPopUpViewController") as! PrompetPopUpViewController
        prompetPopUpViewController.titleString = self.offersDetailResponse?.ineligibleTitle.asStringOrEmpty()
        prompetPopUpViewController.messageString = self.offersDetailResponse?.ineligibleMsg.asStringOrEmpty()
        prompetPopUpViewController.prompetType = GENERICPOPUP
        prompetPopUpViewController.okButtonTitleColor = "#353738"
        prompetPopUpViewController.okButtonBGColor = "#FFCC00"
        prompetPopUpViewController.modalTransitionStyle = .crossDissolve
        prompetPopUpViewController.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.router?.presentViewController(vc: prompetPopUpViewController)
        }
    }
    
    //MARK: init Payment method
    
    func initPayment(for type: OfferType) {
        
        createPayment.selectedPaymentItem = SelectedPaymentItem()
        createPayment.selectedPaymentItem?.selectedItem = "coupon"
        
        if (self.isFromGamification)
        {
            createPayment.selectedPaymentItem?.offerIdentifier = "TREASURE_CHEST_OFFER"
        }
        
        createPayment.selectedPaymentOption = SelectedPaymentOption()
        createPayment.selectedPaymentOption?.paymentType = "free"
        
        if (self.isFromEtisalatOffersSection) {
            createPayment.isEtisalatDOD = true
        }
        
        if type == .etisalat {
            createPayment.selectedPaymentItem?.selectedItem = "eService"
        } else {
            createPayment.quantity = voucherQuantity
        }
        
        createPayment.accountType = GetEligibilityMatrixResponse.sharedInstance.accountType ?? CommonMethods.loadCustomObject(withKey: "accountType") as? String
        
        let customObject = CommonMethods.loadCustomObject(withKey: kOpenDetailsFrom) as? String
        var  offerTagAdditionalInfo : BaseMainResponseAdditionalInfo?
        
        if  let customObj = customObject, !customObj.isEmpty {
            offerTagAdditionalInfo = BaseMainResponseAdditionalInfo()
            offerTagAdditionalInfo?.name = SOURCE
            offerTagAdditionalInfo?.value = customObj
            
            let tag = String(format: "P_%@_%d_%@", offerTagAdditionalInfo?.value ?? "", offersDetailResponse?.categoryId ?? 0, offersDetailResponse?.offerId ?? "")
            CommonMethods.fireEvent(withTag: tag)
        }
        
        createPayment.additionalInfo = [BaseMainResponseAdditionalInfo]()
        
        if let selectedDeal = self.selectedDealVoucher, let arrayDealVoucher = self.offersDetailResponse?.dealVouchers, !arrayDealVoucher.isEmpty {
            createPayment.offerId = selectedDeal.subOfferID
            let  offerAdditionalInfo = BaseMainResponseAdditionalInfo()
            offerAdditionalInfo.name = "offerId"
            offerAdditionalInfo.value = selectedDeal.offerID
            
            if let tagAdditionalInfo = offerTagAdditionalInfo {
                createPayment.additionalInfo = [offerAdditionalInfo, tagAdditionalInfo]
            }
            else{
                createPayment.additionalInfo = [offerAdditionalInfo]
            }
            
        } else {
            createPayment.offerId = self.offersDetailResponse?.offerId.asStringOrEmpty()
            if let tagAdditionalInfo = offerTagAdditionalInfo {
                createPayment.additionalInfo = [tagAdditionalInfo]
            }
        }
        
        PaymentSummary.sharedClient().paymentMethod = createPayment.selectedPaymentOption?.paymentType
        
        view?.showHud()
        
        services.createPayment(request: createPayment) { [weak self] response in
            self?.view?.hideHud()
            
            self?.view?.enableContinueButton(true)
            self?.transactionNumber = response.transactionNo
            if (response.paymentStatus != 0) {
                if let isFromGamification = self?.isFromGamification, isFromGamification
                {
                    CommonMethods.saveCustomObject(NSNumber(value: false), forKey: SHOW_SCRACTCHCARD)
                }
                
                if (response.paymentStatus == -1)
                {
                    self?.navigateToSubscriptionSummary(isSuccess: false, message: response.responseMsg)
                    
                } else if response.paymentStatus == 1 {
                    self?.navigateToSubscriptionSummary(isSuccess: true, message: "Success".localizedString.capitalizingFirstLetter())
                    
                    self?.postNotificationToRefreshOffers()
                    
                }
            }
            
        } failureBlock: { error in
            self.view?.hideHud()
            self.view?.enableContinueButton(true)
        }
        
    }
    
    
    func postNotificationToRefreshOffers() {
        if self.isFromGamification {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:(OFFER_RELOAD_SERVICE)), object: REFREESH_DEALS_FOR_YOU)
            let notification = Notification(name: Notification.Name(rawValue: OFFER_RELOAD_SERVICE), object: REFREESH_DEALS_FOR_YOU)
            NotificationCenter.default.post(notification)
        } else if self.isFromNearbyOffersSection {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:(OFFER_RELOAD_SERVICE)), object: REFRESH_NEARBY_OFFERS)
            let notification = Notification(name: Notification.Name(rawValue: OFFER_RELOAD_SERVICE), object: REFRESH_NEARBY_OFFERS)
            NotificationCenter.default.post(notification)
        } else if self.isFromEtisalatOffersSection {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:(OFFER_RELOAD_SERVICE)), object: REFRESH_ETISALAT_OFFER_OF_DAY)
            let notification = Notification(name: Notification.Name(rawValue: OFFER_RELOAD_SERVICE), object: REFRESH_ETISALAT_OFFER_OF_DAY)
            NotificationCenter.default.post(notification)
        }
    }
    
    func navigateToSubscriptionSummary(isSuccess: Bool, message: String? = nil) {
        VoucherSubscriptionSummary.destroySharedManager()
        let voucherSubscriptionSummary = VoucherSubscriptionSummary.shared()
        voucherSubscriptionSummary.offersDetailResponse = self.offersDetailResponse
        voucherSubscriptionSummary.relatedOffers = self.relatedOffers
        voucherSubscriptionSummary.transactionNumber = self.transactionNumber ?? ""
        voucherSubscriptionSummary.cbdDetailResponse = self.cbdDetailResponse
        let vc = voucherSubscriptionSummary.navigateToSubscriptionSummary(isSuccess: isSuccess, message: message)
        router?.navigateToViewController(viewController: vc)
    }
}

extension DiscountAndDetailsPresenter {
    func getRelateOffersFromWebService() {
        let request = GetRecommendedOffersRequestSwift()
        request.offerId = self.offersDetailResponse?.offerId
        request.latitude = GlobalUserLocation.shared.latitude
        request.longitude = GlobalUserLocation.shared.longitude
        request.isGuestUser = isGuestUser
        
        selectVoucherServices.getRelatedOffers(request: request) { getRecommendedOffersResponse in
            self.view?.hideHud()
            if let offers = getRecommendedOffersResponse.offers {
                self.relatedOffers = offers
            }
        } failureBlock: { error in
            self.view?.hideHud()
        }

    }
}
