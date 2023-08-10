//
//  DiscountAndDetailsPresenter.swift
//  House
//
//  Created by Shahroze Zaheer on 10/19/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import CoreLocation
import SmilesBaseMainRequestManager
import SmilesLocationHandler
import SmilesUtilities

let ELIGABLE = "Y"
let SOLD_OUT = "S"
let SOLD_OUT_PREPAID_USER = "R"
let SOLD_OUT_LIMIT1 = "S1"
let SOLD_OUT_LIMIT2 = "S2"
let SOLD_OUT_LIMIT3 = "S3"
let WEEKLY_LIMIT = "L"
let NOT_ELIGABLE = "N"
let NOT_ELIGABLE_OFFER_DIMENSIONS = "E"
let NOT_ELIGABLE_DAY = "D"

public enum LocationTabSelected : Int {
    case MAP = 0, LIST = 1
}

public enum OfferTabSelected : Int {
    case DETAILS = 0, LOCATIONS = 1, TANDC = 2
}

var DiscountAndDetailsTableViewContentOffset: CGPoint = .zero

class DiscountAndDetailsPresenter: NSObject {
    
    // MARK: Properties
    weak var view: DiscountAndDetailsView?
    var router: DiscountAndDetailsWireframe?
    let services = DiscountAndDetailsServices()
    let selectVoucherServices = SelectPaymentMethodServices()
    
    let cbdDetailsLogic = CBDDetailsLogic()
    
    var sectionItems = [BaseSectionModel]()
    
    fileprivate var selectedRow: IndexPath?
    fileprivate var previousSelectedRow: IndexPath?
    
    private var offerId = ""
    private var offerType: String?
    
    var offersDetailResponse: OfferDetailsResponse?
    var merchantLocations: [MerchantLocationSwift]?
    var termsAndConditions = ""
    
    private var currentUserLocation: CLLocation?
    
    var cbdDetailResponse : CBDDetailsResponse?
    
    var isSoldOut  = false
    var isWeeklyLimit = false
    var isFromGamification = false
    var luckyDealExpiryDate = ""
    var birthDayTitle = ""
    var birthDayRedeemedTitle = ""
    let minimumQuantity = 1
    
    var addToFavorite = true
    var shareType: ShareType?
    
    var isPriceCellExpanded = false
    var segmentIndex = 0
    var totalAmount: Double?
    var isSelectDealVoucher = false
    
    var nearbyOffer: OffersList?
    var totalPoints: Int?
    var voucherQuantity: Int?
    
    //Mutahir : To do in swift to objc start
    var selectedDealVoucher: DealVoucherSwift?
    var termsCondtionsAccepted = false
    var isPointsEnabled = false
    var isFromEtisalatOffersSection = false
    var isFromNearbyOffersSection = false
    var isFromDealsForYouSection = false
    var selectedVoucherDomination: VoucherDenomination?
    var isSelectedAmountFromList = false
    var dynamicVoucherAmount: String?
    var etisalatOfferDictionary = [String:Any]()
    var originalPoints: Int?
    var originalPrice: Double?
    //Mutahir : To do in swift to objc end
    
    
    var selectedLocation : LocationTabSelected = .LIST
    var selectedOfferTab : OfferTabSelected = .DETAILS
    var bottomSectionItem : BaseSectionModel?
    var selectedDenomination: Int?
    var selectedDenominationIndex: Int? = 0
    var openDetailsFrom : String?
    var createPayment = CreatePaymentRequest()
    var isVatableOffer = false
    
    
    var segmentControlCellForTabs : DiscountAndDetailsSegmentTableViewCell?
    
    var transactionNumber: String?
    var relatedOffers: [OffersList]?
    var recommendationModelEvent: String?
    var comeFromSummaryForRecommendedOffer: Bool?
    var recommendationModelEventOfDealsForOffer: String?
}

extension DiscountAndDetailsPresenter: DiscountAndDetailsPresentation {
    
    func getNowAction(sender: UIButton) {
        self.didTappedOnGetNowAction(sender: sender)
    }
    
    
    func changeOfferTypeBackground(with offerType: String?, isPromotionalOffer: Bool) -> UIColor? {
        if let offer = offerType, !offer.isEmpty {
            let type = offer.replacingOccurrences(of: " ", with: "")
            if type.lowercased() == "Voucher".lowercased() {
                return isPromotionalOffer ? CommonMethods.color(fromHexString: "#E7B900") : CommonMethods.color(fromHexString: "#384871")
            } else if type.lowercased() == "discount".lowercased() {
                return isPromotionalOffer ? CommonMethods.color(fromHexString: "#65C3B9") : CommonMethods.color(fromHexString: "#65C3B9")
            } else if type.lowercased() == "dealvoucher".lowercased() {
                return isPromotionalOffer ? CommonMethods.color(fromHexString: "#E7B900") : CommonMethods.color(fromHexString: "#E98E4D")
            } else {
                return isPromotionalOffer ? CommonMethods.color(fromHexString: "#65C3B9") : CommonMethods.color(fromHexString: "#65C3B9")
            }
        }
        
        return nil
    }
    
    func viewDidload(withofferID offerID: String?, type offerType: String?, isFromGamification:Bool,luckyDealExpiryDate: String,birthDayTitle : String, birthDayRedeemedTitle:String, etisalatOfferDictionary: [String:Any], isFromEtisalatOffersSection: Bool, isFromNearbyOffersSection: Bool, isFromDealsForYouSection: Bool,openDetailsFrom :String?, recommendationModelEvent: String?, comeFromSummaryForRecommendedOffer: Bool?, recommendationModelEventOfDealsOffer: String?) {
        self.offerId = offerID.asStringOrEmpty()
        self.offerType = offerType
        self.isFromGamification = isFromGamification
        self.luckyDealExpiryDate = luckyDealExpiryDate
        self.birthDayTitle = birthDayTitle
        self.birthDayRedeemedTitle = birthDayRedeemedTitle
        self.etisalatOfferDictionary = etisalatOfferDictionary
        self.isFromEtisalatOffersSection = isFromEtisalatOffersSection
        self.isFromNearbyOffersSection = isFromNearbyOffersSection
        self.isFromDealsForYouSection = isFromDealsForYouSection
        self.openDetailsFrom = openDetailsFrom
        self.recommendationModelEvent = recommendationModelEvent
        self.comeFromSummaryForRecommendedOffer = comeFromSummaryForRecommendedOffer
        self.recommendationModelEventOfDealsForOffer = recommendationModelEventOfDealsOffer
        getUserCurrentLocation()
        getCBDCreditCardFromWebService()
     
    }
    
    // TODO: implement presentation methods
    
    func rowModelForChildOffersQuantity(childOffers: [OfferDetailsResponse]) -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        
        for (index, offer) in childOffers.enumerated() {
            let amountToAddString = "\(AppCommonMethods.getWithAEDValue(string: "\(offer.dirhamValue.asDoubleOrEmpty())"))"
            
            var pointsDescription = ""
            
            if let pointsValue = offer.pointsValue, pointsValue > 0 {
                pointsDescription = "\("OrTitle".localizedString.lowercased()) \(pointsValue) \("PTSTitle".localizedString)"
            }
            let cellValue = DiscountAndDetailsOfferQuantityTableViewCellModel(cellTitle: offer.offerTitle.asStringOrEmpty(), cellDescription: offer.offerDescription.asStringOrEmpty(), cellPrice: amountToAddString, voucherQuantity: minimumQuantity, isAccountTotalLimit:offer.isAccountTotalLimit, isFree: offer.isFree(), pointsDescription: pointsDescription, delegate: self, isPriceCellExpanded: isPriceCellExpanded)
            if isSoldOut {
                cellValue.isSoldOut = true
            }
            let offerQuantityCell = DiscountAndDetailsOfferQuantityTableViewCell.rowModel(value: cellValue)
            offerQuantityCell.tag = index
            rowSectionModels.rowItems.append(offerQuantityCell)
        }
        
        return rowSectionModels
        
    }
    
    func rowModelForSingleQuantity(enable: Bool) -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let cellValue = DiscountAndDetailsQuantityTableViewCellModel(cellShouldEnable: enable, voucherQuantity: minimumQuantity, delegate: self)
        if isSoldOut {
            cellValue.isSoldOut = true
        }
        let offerQuantityCell = DiscountAndDetailsQuantityTableViewCell.rowModel(value: cellValue)
       
        rowSectionModels.rowItems.append(offerQuantityCell)
        self.voucherQuantity = minimumQuantity
    
        self.totalAmount = Double(minimumQuantity) * (self.offersDetailResponse?.dirhamValue.asDoubleOrEmpty() ?? 0.0)
        if isSoldOut {
            view?.enableContinueButton(false)
        } else {
            view?.enableContinueButton(true)
        }
        return rowSectionModels
    }
    
    
    func rowModelForSegmentControl() -> BaseSectionModel{
        let rowSectionModels = BaseSectionModel()
        let segmentTableCell = DiscountAndDetailsSegmentTableViewCell.rowModel(delegate: self)
        rowSectionModels.rowItems.append(segmentTableCell)
        return rowSectionModels
    }
    
    
    func rowModelForLocationsAndTAndC(index: Int, tAndC: String) -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        
        //        let modelForSegment = DiscountAndDetailsSegmentTableViewCellModel()
        //        modelForSegment.isMapViewButtonSelected = selectedLocation == .MAP ? true : false
        //        modelForSegment.selectedIndex = index
        //
        
        
        if index == 0 {
            
            
        } else if index == 1 {
            
            if selectedLocation  == .LIST{
                if let merchantLoc = offersDetailResponse?.merchantLocation, merchantLoc.count > 0 {
                    for merchants in merchantLoc {
                        
                        let discountDetailModel = DiscountAndDetailsLocationTableModel()
                        discountDetailModel.locationName = merchants.locationName
                        discountDetailModel.locationAddress = merchants.locationAddress
                        discountDetailModel.distance = merchants.distance
                        discountDetailModel.locationLatitude = merchants.locationLatitude
                        discountDetailModel.locationLongitude = merchants.locationLongitude
                        discountDetailModel.locationPhoneNumber = merchants.locationPhoneNumber
                        
                        let rowModel = DiscountAndDetailsLocationTableViewCell.rowModel(model: discountDetailModel, delegate: self)
                        rowSectionModels.rowItems.append(rowModel)
                    }
                }
                
            }else{
                if let merchantLoc = offersDetailResponse?.merchantLocation, merchantLoc.count > 0 {
                    let mapCell = DiscountAndDetailsMapViewTableViewCell.rowModel(value: merchantLoc, categoryId: "\(self.offersDetailResponse?.categoryId ?? 1)")
                    rowSectionModels.rowItems.append(mapCell)
                }
                
            }
            
        } else if index == 2 {
            let termsCell = DiscountAndDetailsTermsAndConditionsTableViewCell.rowModel(value: tAndC)
            rowSectionModels.rowItems.append(termsCell)
        }
        
        
        return rowSectionModels
    }
    
    func rowModelForHowItWorks() -> BaseRowModel {
        
        let howItWorkModel = DiscountAndDetailsHowItWorksTableModel()
        howItWorkModel.titleValue = "HIWTitle".localizedString
        
        let rowModel = DiscountAndDetailsHowItWorksTableViewCell.rowModel(model: howItWorkModel,delegate:self)
        
        return rowModel
    }
    
    func rowModelForOrderNow() -> BaseRowModel {
        let orderNowModel = DiscountAndDetailsOrderNowTableModel()
        orderNowModel.titleValue = offersDetailResponse?.orderFoodDetails?.title ?? ""
        orderNowModel.btnTextValue = offersDetailResponse?.orderFoodDetails?.description
        orderNowModel.imageURL = offersDetailResponse?.orderFoodDetails?.image
        let rowModel = DiscountAndDetailsOrderNowTableViewCell.rowModel(model: orderNowModel,delegate:self)
        return rowModel
    }
    
    func rowModelAboutOffer(title: String, description: String) -> BaseRowModel {
        let model = DiscountAndDetailsAboutTableViewCellModel(isDescExpanded: false, description: description, addReadLess: false)
        let aboutOfferCell = DiscountAndDetailsAboutTableViewCell.rowModel(value: model, delegate: self)
        aboutOfferCell.rowTitle = title
        
        return aboutOfferCell
    }
    
    func rowModelBogo() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let aboutOfferCell = BogoCustomTableCell.rowModel(value: BogoCustomTableCellModel())
        rowSectionModels.rowItems.append(aboutOfferCell)
        
        return rowSectionModels
    }
    
    func rowModelCBD(response: CBDDetailsResponse) -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let cbdCell = CBDCreditCardBannerTableViewCell.rowModel(model: response)
        rowSectionModels.rowItems.append(cbdCell)
        
        return rowSectionModels
    }
    
    func rowModelRelatedOffers(relatedOffer: [OffersList]) -> BaseRowModel {
        
        let cell = DiscountAndDetailsRelatedOffersTableViewCell.rowModel(model: relatedOffer, delegate: self, tag: 102, scrollDirection: .horizontal)
        
        return cell
    }
    
    func generateRowModelsForDealsAndDiscount() {
        sectionItems = []
        if let offersResponse = offersDetailResponse {
            if !offersResponse.isAccountTotalLimit{
                voucherQuantity = 1
                self.view?.enableContinueButton(true)
            }
            self.checkIfSoldOutOrWeeklyLimit(offerType: offersResponse.offerType ?? .discount)
            
            if offersResponse.offerType == .voucher{
                if isFromGamification {
                    let dealsViewController = SuperDealsViewController()
                    dealsViewController.isFromGamification = true
                    dealsViewController.registerEvent(forGamification: "true", isPurchase: "false", itemId: offersResponse.offerId, partnerName: offersResponse.partnerName, categoryId: String(format: "%d", offersResponse.categoryId ?? 0))
                }
            }
            
            
            var navigationTitle = offersResponse.partnerName ?? ""
            
            if isSoldOut {
                self.view?.enableContinueButton(false)
            }
            
            switch offersResponse.offerType ?? .discount {
            case .discount:
                self.createRowsForDiscountOffer()
                navigationTitle = "discountTitle".localizedString.capitalizingEveryFirstLetter()
            case .dealVoucher:
                navigationTitle = "DealVoucherTitle".localizedString.capitalizingEveryFirstLetter()
            case .etisalat:
                self.createRowsForDiscountOffer()
                navigationTitle = "EtisalatPackagesTitle".localizedString.capitalizingEveryFirstLetter()
            case .voucher:
                self.createRowsForDiscountOffer()
                navigationTitle = "CashVoucherTitle".localizedString.capitalizingEveryFirstLetter()
                let modelForCashVoucher = rowModelForCashVouchers()
                self.sectionItems.append(modelForCashVoucher)
            }
            
            self.originalPrice = offersResponse.dirhamValue
            self.originalPoints = offersResponse.pointsValue
            
            if (self.isFromGamification)
            {
                navigationTitle = "LuckyDealTitle".localizedString.uppercased()
            }
            
            if offersResponse.offerType == .dealVoucher {
                if let offers = offersResponse.dealVouchers, !offers.isEmpty {
                    let childOffersModel = rowModelDealVoucherChildOffersQuantity(childOffers: offers)
                    self.sectionItems.append(childOffersModel)
                }
            } else {
                // Child Offers Section
                if let offers = offersResponse.childOffers, !offers.isEmpty {
                    let childOffersModel = rowModelForChildOffersQuantity(childOffers: offers)
                    self.sectionItems.append(childOffersModel)
                } else {
                    if let cinemaOffer = offersResponse.cinemaOfferFlag, cinemaOffer {} else {
                        if offersResponse.offerType == .discount && offersResponse.isAccountTotalLimit{
                            let singleQuantityModel = rowModelForSingleQuantity(enable: (offersResponse.eligibleFlag?.lowercased() == SOLD_OUT) ? false : true)
                            
                            self.sectionItems.append(singleQuantityModel)
                        }
                    }
                }
            }
            
            var totalAmount = offersResponse.dirhamValue.asDoubleOrEmpty()
            
            var agreeTermsModel: BaseSectionModel?
            
            let bogoOfferModel = rowModelBogo()
            if let offerType = self.offersDetailResponse?.offerType {
                switch offerType {
                case .discount:
                    if offersResponse.lifestyleSubscriberFlag == false && offersResponse.isBirthdayOffer == false  && offersResponse.isRedeemedOffer == false{
                        
                        if let getUserProfile = getUserProfileResponse.sharedClient(), let onAppStartObjectResponse = getUserProfile.onAppStartObjectResponse, let lifeStyleDiscountFlag = onAppStartObjectResponse.lifeStyleDiscountFlag, lifeStyleDiscountFlag == TRUE_VALUE {
                            if let notEligibleObject = GetEligibilityMatrixResponse.sharedInstance.notEligibleObject, notEligibleObject.lifestyle {
                                self.sectionItems.append(bogoOfferModel)
                            }
                        }
                    }
                    
                    break
                case .dealVoucher:
                    if getUserProfileResponse.sharedClient()?.onAppStartObjectResponse?.lifeStyleVoucherFlag == TRUE_VALUE{
                        if !(GetEligibilityMatrixResponse.sharedInstance.notEligibleObject?.lifestyle ?? true){
                            if offersResponse.lifestyleSubscriberFlag == false{
                                self.sectionItems.append(bogoOfferModel)
                            }
                            
                        }
                    }
                    
                    self.isVatableOffer = true
                    
                case .etisalat:
                    agreeTermsModel = self.rowModelAgreeTermsForEtisalat()
                   
                    if totalAmount > 0 {
                        self.voucherQuantity = minimumQuantity
                    }
                case .voucher:
                    if totalAmount > 0 {
                        self.voucherQuantity = minimumQuantity
                    }
                }
            }
            
            
            if let offerType = self.offersDetailResponse?.offerType, offerType != .etisalat {
                if self.showCBDBannerWithResponse() {
                    if let cbdResponse = self.cbdDetailResponse {
                        let cbdRowModel = rowModelCBD(response: cbdResponse)
                        self.sectionItems.append(cbdRowModel)
                    }
                }
            }
            
            let separaterModel = self.separaterModel()
            self.sectionItems.append(separaterModel)
            
            if let offerType = self.offersDetailResponse?.offerType, offerType != .etisalat {
                if let promotionalText = offersResponse.offerPromotionText, !promotionalText.isEmpty, promotionalText != "\n" {
                    self.sectionItems.append(rowModelForOfferPromotional())
                    let separaterModel = self.separaterModel()
                    self.sectionItems.append(separaterModel)
                    
                }
            }
            
            if let offerType = self.offersDetailResponse?.offerType, offerType != .etisalat {
                let segmentModel = self.rowModelForSegmentControl()
                self.sectionItems.append(segmentModel)
                
                self.termsAndConditions = offersResponse.termsAndConditions ?? ""
                self.merchantLocations = offersResponse.merchantLocation
                let locationAndTAndCModel = rowModelForLocationsAndTAndC(index: self.segmentIndex, tAndC: self.termsAndConditions)
                self.sectionItems.append(locationAndTAndCModel)
            }
            
            
            self.generateRowModelsForDealsAndDiscountForSelectedTab()
            
            if let rowModelForAgreeTerms = agreeTermsModel {
                self.sectionItems.append(rowModelForAgreeTerms)
            }
            
            self.totalPoints = originalPoints

            if let denomination = selectedVoucherDomination {
                totalAmount = Double(denomination.denominationAED ?? 0)
                self.totalPoints = denomination.denominationPoint
            }
            
            self.totalAmount = totalAmount

            if totalAmount > 0 {
                let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: totalAmount.fractionDigitsRounded(to: 2)))"
                self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: self.voucherQuantity ?? 0, isVatable: self.isVatableOffer)
            }
            
            self.view?.updateNavigationTitle(title: navigationTitle)
            
            view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
        }
    }
    
    func generateRowModelsForDealsAndDiscountForSelectedTab(){
        
        if selectedOfferTab == .DETAILS{
            bottomSectionItem = BaseSectionModel()
            
            if let details = offersDetailResponse?.whatYouGetList, details.count > 0 {
                for value in details {
                    let bulletModel = DiscountAndDetailsBulletCellModel()
                    bulletModel.detailText = value
                    let cell = DiscountAndDetailsBulletCell.rowModel(value: bulletModel)
                    bottomSectionItem?.rowItems.append(cell)
                }
            }
            
            if let offerType = self.offersDetailResponse?.offerType, offerType == .discount {
                if let offerValidDate = offersDetailResponse?.offerValidDate, offerValidDate.count > 0 {
                    let validityModel = DiscountAndDetailsValidityTableViewCellModel()
                    validityModel.validTillDate = SwiftUtli.shared.convertStringToDate(format: "dd-MM-yyyy", dateInString: offerValidDate, targetFormat: "dd MMM YYYY")
                    if let estimatedSavings = offersDetailResponse?.estimatedSavings, estimatedSavings > 0 {
                        validityModel.estimatedSavings = "\(AppCommonMethods.getWithAEDValuePrefix(string: estimatedSavings.fractionDigitsRounded(to: 2)))"
                    }
                    let validityCell = DiscountAndDetailsValidityTableViewCell.rowModel(value: validityModel)
                    bottomSectionItem?.rowItems.append(validityCell)
                }
                
                bottomSectionItem?.rowItems.append(separaterModelRow())
            }
            
            let howItWorksModel = rowModelForHowItWorks()
            bottomSectionItem?.rowItems.append(howItWorksModel)
            bottomSectionItem?.rowItems.append(separaterModelRow())
            
            if let desc = offersDetailResponse?.offerDetailDescription,desc.count > 0, !desc.isEmpty{
                let aboutOfferModel = rowModelAboutOffer(title: offersDetailResponse?.partnerName ?? "" , description: desc)
                bottomSectionItem?.rowItems.append(aboutOfferModel)
                bottomSectionItem?.rowItems.append(separaterModelRow())
            }
            if let _ = offersDetailResponse?.orderFoodDetails?.restaurantName {
                if bottomSectionItem?.rowItems.last?.rowCellIdentifier == "SpaceCellWithSeperator" {
                    bottomSectionItem?.rowItems.removeLast()
                }
                let rowModel = rowModelForOrderNow()
                bottomSectionItem?.rowItems.append(rowModel)
            }
       
            
            if let relatedOffers = offersDetailResponse?.relatedOffers, relatedOffers.count > 0 {
                let relatedOffersModel = rowModelRelatedOffers(relatedOffer: relatedOffers)
                bottomSectionItem?.rowItems.append(relatedOffersModel)
            }
            
            self.sectionItems.append(bottomSectionItem!)
        }else{
            if let bt = bottomSectionItem,bt.rowItems.count > 0{
                sectionItems.last?.rowItems.removeAll()
                sectionItems.removeLast()
                bt.rowItems.removeAll()
                
            }
        }
        
        
    }
    
    func showCBDBannerWithResponse() -> Bool {
        if let isCbdCardHolder = self.cbdDetailResponse?.isCbdCardHolder, !isCbdCardHolder {
            if self.offersDetailResponse?.offerType != .etisalat {
                if (!(self.offersDetailResponse?.isBirthdayOffer ?? true) && !(self.offersDetailResponse?.isRedeemedOffer ?? true)){
                    return true
                }
            }
        }
        return false
    }
    
    func getUserCurrentLocation() {
        
        self.view?.showHud()
        LocationManager.shared.getLocation { [weak self] (location:CLLocation?, error:NSError?) in
            self?.currentUserLocation = location
            self?.callGetOfferDetailService(offerID: self?.offerId ?? "")
        }

    }
    
    
    func callGetOfferDetailService(offerID:String){
        self.getOfferDetailsFromWebServices(offerID: offerID)
    }
    
    
    
    fileprivate func getCBDCreditCardFromWebService() {
        if let notEligibleObj = GetEligibilityMatrixResponse.sharedInstance.notEligibleObject, !notEligibleObj.cbdAcquisition{
            
            cbdDetailsLogic.getUserCbdDetail(successBlocka: { [weak self] response in
                if let cbdModel = CBDDetailsResponse(dictionary: response.toDictionary()) {
                    self?.cbdDetailResponse = cbdModel
                }
                
                self?.generateRowModelsForDealsAndDiscount()
                
            }) {  error  in
            }
        }
        
    }
    
    
    func addToFavoritesTapped() {
        if isGuestUser {
            router?.presentGuestPopUp()
        } else {
            if addToFavorite {
                // show pop up
                let prompetViewController = self.showPrompetPopUp(title: LanguageManager.sharedInstance().getLocalizedString(forKey: "RemoveItemTitle"), message: LanguageManager.sharedInstance().getLocalizedString(forKey: "RemoveWishlistPopupRestaurantTitle"), popUpTag: 81)
                prompetViewController.delegate = self
                (UIApplication.shared.delegate as! AppDelegate).tabbarViewController?.present(prompetViewController, animated: true, completion: nil)
            } else {
                self.addOfferToFavoriteFromWebService(addToFavorite: true, offerId: self.offersDetailResponse?.offerId,isNavBar: true)
            }
        } 
    }
    
    
    func shareTapped() {
        let shareURL = CommonMethods.getConfigurationForCurrentScheme("SHARE_URL") ?? ""
        let shareUrl = String(format: shareURL, self.offersDetailResponse?.offerId ?? "", self.offerType ?? "", LanguageManager.sharedInstance().currentLanguage == Arabic ? "ar" : "en", self.offersDetailResponse?.offerTitle ?? "", self.offersDetailResponse?.partnerName ?? "")
        
        let urlString = shareUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        if let string = urlString, !string.isEmpty {
            let shareItems = [string]
            
            if shareItems.count > 0 {
                let activityViewController = UIActivityViewController(activityItems: shareItems as [Any], applicationActivities: nil)
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToWeibo,
                                                                UIActivity.ActivityType.print,
                                                                UIActivity.ActivityType.copyToPasteboard,
                                                                UIActivity.ActivityType.assignToContact,
                                                                UIActivity.ActivityType.saveToCameraRoll,
                                                                UIActivity.ActivityType.addToReadingList,
                                                                UIActivity.ActivityType.postToTencentWeibo,
                                                                UIActivity.ActivityType.airDrop]
                
                // present the view controller
                view?.presentShareActivity(vc: activityViewController)
                
            }
        }
    }
    
    func addEventsOnShare(with activityType: UIActivity.ActivityType) {
        
        CommonMethods.fireEvent(withName: kSelectionOfChannel, parameters: ["activityType" : activityType])
        CommonMethods.fireEvent(withName: kPostingTheMessage, parameters: ["activityType" : activityType])
        
        if activityType == UIActivity.ActivityType.mail {
            self.shareType = EMAIL_SHARE_TYPE
        } else if activityType == UIActivity.ActivityType.postToFacebook {
            self.shareType = FACEBOOK_SHARE_TYPE
        } else if activityType == UIActivity.ActivityType.postToTwitter {
            self.shareType = TWITTER_SHARE_TYPE
        } else if activityType.rawValue == "ph.telegra.Telegraph.Share" {
            self.shareType = FACEBOOK_SHARE_TYPE
        } else {
            self.shareType = FACEBOOK_SHARE_TYPE
        }
        
        let shareAdditionalInfo = AdditionalInfo()
        shareAdditionalInfo.name = "shareType"
        shareAdditionalInfo.value = String(FACEBOOK_SHARE_TYPE.rawValue)
        
        let categoryIdAdditionalInfo = AdditionalInfo()
        categoryIdAdditionalInfo.name = "categoryId"
        categoryIdAdditionalInfo.value = String(format: "%.2f", self.offersDetailResponse?.categoryId ?? 0)
        
        let itemIdAdditionalInfo = AdditionalInfo()
        itemIdAdditionalInfo.name = "itemId"
        itemIdAdditionalInfo.value = self.offersDetailResponse?.offerId
        
        let priceAdditionalInfo = AdditionalInfo()
        priceAdditionalInfo.name = "price"
        priceAdditionalInfo.value = String(format: "%.2f", self.offersDetailResponse?.dirhamValue ?? 0)
        
        let partnerNameAdditionalInfo = AdditionalInfo()
        partnerNameAdditionalInfo.name = "partnerName"
        partnerNameAdditionalInfo.value = self.offersDetailResponse?.partnerName
        
        let offerStatusAdditionalInfo = AdditionalInfo()
        offerStatusAdditionalInfo.name = "offerStatus"
        offerStatusAdditionalInfo.value = "1"
        
        let offerTypeAdditionalInfo = AdditionalInfo()
        offerTypeAdditionalInfo.name = "type"
        offerTypeAdditionalInfo.value = self.offerType
        
        let masterController = MasterViewController.init()
        masterController.registerEventWithWebService(with: OFFER_SHARING_EVENT , shareType: self.shareType!, additionalIfno: [shareAdditionalInfo,offerTypeAdditionalInfo,offerStatusAdditionalInfo,partnerNameAdditionalInfo,priceAdditionalInfo,itemIdAdditionalInfo,categoryIdAdditionalInfo])
    }
    
    
    func showPrompetPopUp(title: String, message: String, popUpTag: Int) -> PrompetPopUpViewController {
        let prompetPopUpViewController = UIStoryboard.homeStoryboard.instantiateViewController(ofType: PrompetPopUpViewController.self)
        prompetPopUpViewController.titleString = title
        prompetPopUpViewController.messageString = message
        prompetPopUpViewController.popUpTag = popUpTag
        prompetPopUpViewController.modalPresentationStyle = .overCurrentContext
        prompetPopUpViewController.modalTransitionStyle = .crossDissolve
        return prompetPopUpViewController
    }
    
    func isDealVoucherSelected() -> Bool {
        return self.isSelectDealVoucher
    }
}


// MARK:- API Calls
extension DiscountAndDetailsPresenter {
    
    // MARK- Get offer details
    func viewDidScroll(_ scrollView: UIScrollView) {
        view?.didScrollTableView(scrollView: scrollView)
    }
    
    func getOfferDetailsFromWebServices(offerID: String?) {
        
        let getOfferDetailsRequest = GetOfferDetailsRequest()
        getOfferDetailsRequest.offerId = offerID
        
        if let longitude = self.currentUserLocation?.coordinate.longitude, let latitude = self.currentUserLocation?.coordinate.latitude, longitude > 0, latitude > 0
        {
            getOfferDetailsRequest.longitude = String(format: "%f", longitude)
            getOfferDetailsRequest.latitude = String(format: "%f", latitude)
        }
        
        
        if let opendetail = self.openDetailsFrom {
            let offerAdditionalInfo : BaseMainResponseAdditionalInfo = BaseMainResponseAdditionalInfo()
            offerAdditionalInfo.name = SOURCE
            offerAdditionalInfo.value = opendetail
            getOfferDetailsRequest.additionalInfo = [offerAdditionalInfo]
            CommonMethods.saveCustomObject(opendetail, forKey: kOpenDetailsFrom)
            self.openDetailsFrom = nil
            
        }else{
            CommonMethods.removeCustomObject(withKey: kOpenDetailsFrom)
        }
        
        getOfferDetailsRequest.isGuestUser = isGuestUser
        
        services.getOfferDetails(request: getOfferDetailsRequest, completionHandler: { [weak self] response in
            self?.offersDetailResponse = response

            if let isWishList = self?.offersDetailResponse?.isWishlisted {
                self?.isOfferAddedToFavorite(isAdded: isWishList)
            }
            
            if let offerDetail = self?.offersDetailResponse{
                self?.updateTitleAndImage(offerDetail: offerDetail)
            }
            
            if let offerId = self?.offersDetailResponse?.offerId, let categoryName = self?.getCategoryName(additionalInfo: self?.offersDetailResponse?.additionalInfo ?? []) {
                SmilesCommonMethods.registerPersonalizationEvent(for: .viewOffer, offerId: offerId, categoryName: categoryName)
            }
            
            self?.generateRowModelsForDealsAndDiscount()
            self?.getRelateOffersFromWebService()
            
        }) { [weak self]  error in
            self?.view?.hideHud()
            self?.offersDetailResponse = nil
            self?.view?.showError(shouldHide: false, error: .somethingWrong, errorMsg: AppCommonMethods.languageIsArabic() ? error?.errorDescriptionAr ?? "" : error?.errorDescriptionEn ?? "")
            self?.generateRowModelsForDealsAndDiscount()
        }
    }
    
    
    func addOfferToFavoriteFromWebService(addToFavorite: Bool, offerId: String?, isNavBar: Bool) {
        let opertation = addToFavorite ? 1 : 2
        
        services.addOfferToFavorite(operation: opertation, offerId: offerId.asStringOrEmpty(), completionHandler: { [weak self] response in
            
            if let status = response.updateWishlistStatus, status {
                if opertation == 1 {
                    
                    if isNavBar {
                        self?.isOfferAddedToFavorite(isAdded: true)
                    } else {
                        self?.isOtherOfferAddedToFavorite(isAdded: true)
                    }
                }
                else {
                    if isNavBar {
                        self?.isOfferAddedToFavorite(isAdded: false)
                    }else {
                        self?.isOtherOfferAddedToFavorite(isAdded: false)
                    }
                }
            }
            else {
                if isNavBar {
                    self?.isOfferAddedToFavorite(isAdded: false)
                } else {
                    self?.isOtherOfferAddedToFavorite(isAdded: false)
                }
            }
            
            self?.view?.wishlistUpdated()
        }) { [weak self] _ in
            if isNavBar {
                self?.isOfferAddedToFavorite(isAdded: false)
            } else {
                self?.isOtherOfferAddedToFavorite(isAdded: false)
            }
        }
    }
    
    func isOfferAddedToFavorite(isAdded: Bool) {
        self.addToFavorite = isAdded
        view?.updateFavoritesButtonIcon(isFavorite: self.addToFavorite)
    }
    
    
    func isOtherOfferAddedToFavorite(isAdded: Bool) {
        
        if let relatedOffers = self.offersDetailResponse?.relatedOffers, relatedOffers.count > 0 {
            guard let offerIndex = relatedOffers.firstIndex(where: {$0 === self.nearbyOffer}) else {return}
            self.offersDetailResponse?.relatedOffers?[offerIndex].isWishlisted = isAdded
            generateRowModelsForDealsAndDiscount()
        }
    }
    
    func updateTitleAndImage(offerDetail: OfferDetailsResponse) {
        view?.updateTitleAndImage(offerDetail: offerDetail)
    }
}

extension DiscountAndDetailsPresenter: BaseDataSourceDelegate {
    func navigateToRestaurantDetail(restaurantName: String, menuItemType: String) {
        var nextViewController:UIViewController!
        if LocationStateSaver().checkIfLocationIdIsNil() || LocationStateSaver().checkIfMambaIdIsNil() {
            nextViewController = LocationAccessAlertRouter.setupModule()
        }
        else if let eligibilityVC = EligbiltyViewController.getFoodOrderEligibilityViewController() {
            nextViewController = eligibilityVC
        } else {
            let restaurantDetailsViewController = RestaurantDetailRevampRouter.setupModule()
            let restaurantObj = Restaurant()
            restaurantObj.restaurantName = restaurantName
            restaurantDetailsViewController.selectedRestaurantObj = restaurantObj
            restaurantObj.menuItemType = menuItemType
            nextViewController = restaurantDetailsViewController
        }
        self.router?.navigateToViewController(viewController: nextViewController)
    }
    func didSelectItemInRowModel(rowModel model: BaseRowModel, rowModelValue value: Any, atIndexPath indexPath: IndexPath) {
        
        if let val = value as? DiscountAndDetailsBulletCellModel{
            print("---- \(val)")
            self.detectHtmlLink(str: val.detailText ?? "")
        }
        
        if let _ = value as? DiscountAndDetailsOrderNowTableModel {
            if let restaurantName = offersDetailResponse?.orderFoodDetails?.restaurantName,let menuItemType = offersDetailResponse?.orderFoodDetails?.menuItemType {
                self.navigateToRestaurantDetail(restaurantName:restaurantName, menuItemType: menuItemType)
            }
        }
        else if let _ = value as? DiscountAndDetailsHowItWorksTableModel {
            print("didSelectItemInRowModel")
            prepareForHowItWorks()
        } else if let _ = value as? CBDDetailsResponse {
            
            if let redirectionURL = self.cbdDetailResponse?.cbdRedirectionUrl, !redirectionURL.isEmpty {
                HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType, urlScheme: "billAndRechargePage", offerId: nil, bannerType: nil, eventName: "cbd_redirection_url")
                CommonMethods.openExternalUrl(redirectionURL)
            } else {
         
                if let newCBD = getUserProfileResponse.sharedClient()?.onAppStartObjectResponse?.cbd_new_flow_flag,!newCBD{
                    let cbdCreditCardDetailsViewController = CommonMethods.getViewController(fromStoryboardName: "CBDCreditCards", andIdentifier: "CBDCreditCardDetailsViewController") as? CBDCreditCardDetailsViewController
                    cbdCreditCardDetailsViewController?.cbdDetailsResponse = self.cbdDetailResponse
                    cbdCreditCardDetailsViewController?.fromScreen = CBD_BillPaymentScreen
                    
                    let navigationController = UINavigationController(rootViewController: cbdCreditCardDetailsViewController!)
                    navigationController.isNavigationBarHidden = true
                    navigationController.modalTransitionStyle = .crossDissolve
                    navigationController.modalPresentationStyle = .overCurrentContext
                    router?.presentViewController(vc: navigationController)
                } else {
                    let cbdCreditCardDetailsViewController = CBDDetailsRevampRouter.setupModule()
                    
                    cbdCreditCardDetailsViewController.cbdDetailsResponse = self.cbdDetailResponse
                    cbdCreditCardDetailsViewController.fromScreen = CBD_BillPaymentScreen;
                    cbdCreditCardDetailsViewController.hidesBottomBarWhenPushed = true
                    self.router?.navigateToViewController(viewController: cbdCreditCardDetailsViewController)
                    
                }
                
            }
        }else if let relatedOffer = value as? OffersList{
            //relatedOffers
            if let offerID = relatedOffer.offerId{
                self.recommendationModelEvent = relatedOffer.recommendationModelEvent
                
                // Event for related offer tapped
                HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType, urlScheme: nil, offerId: offerID, bannerType: nil, eventName: "related_offers_clicked", recommendationModelEvent: recommendationModelEvent)
                
                viewDidload(withofferID: offerID, type: relatedOffer.offerType, isFromGamification: self.isFromGamification, luckyDealExpiryDate: self.luckyDealExpiryDate, birthDayTitle: self.birthDayTitle, birthDayRedeemedTitle: self.birthDayRedeemedTitle, etisalatOfferDictionary: etisalatOfferDictionary, isFromEtisalatOffersSection: isFromEtisalatOffersSection, isFromNearbyOffersSection: isFromNearbyOffersSection, isFromDealsForYouSection: isFromDealsForYouSection,openDetailsFrom: openDetailsFrom, recommendationModelEvent: relatedOffer.recommendationModelEvent, comeFromSummaryForRecommendedOffer: self.comeFromSummaryForRecommendedOffer, recommendationModelEventOfDealsOffer: self.recommendationModelEventOfDealsForOffer)
            }
        }else if  let _ = value as? BogoCustomTableCellModel{
            let bogoViewController = SubscriptionRevampRouter.setupModule()
            bogoViewController.shouldShowLeftButtons = true
            router?.navigateToViewController(viewController: bogoViewController)
        }
    }
}

extension DiscountAndDetailsPresenter: DiscountAndDetailsSegmentTableViewCellDelegate {
    func discountCell(_ cell: DiscountAndDetailsSegmentTableViewCell, didChange segment: HMSegmentedControl) {
        segmentControlCellForTabs = cell
        self.segmentIndex = segment.selectedSegmentIndex
        if LanguageManager.sharedInstance()?.currentLanguage == Arabic {
            if self.segmentIndex == 0 {
                self.segmentIndex = 2
            } else if self.segmentIndex == 2 {
                self.segmentIndex = 0
            }
        }
        selectedOfferTab = OfferTabSelected(rawValue: self.segmentIndex) ?? .DETAILS
        generateRowModelsForDealsAndDiscountForSelectedTab()
        showSelectedTabData(cell: cell)
    }
    
    
    func showSelectedTabData(cell: DiscountAndDetailsSegmentTableViewCell){
        
        
        if let index = view?.indexForSegmentCell(cell: cell) {
            let locationAndTAndCModel = rowModelForLocationsAndTAndC(index: self.segmentIndex, tAndC: self.termsAndConditions )
            
            let item = sectionItems[index.section]
            
            item.rowItems.removeAll { model in
                model.rowCellIdentifier != "DiscountAndDetailsSegmentTableViewCell"
            }
            
            
            item.rowItems.append(contentsOf: locationAndTAndCModel.rowItems)
            item.rowItems[0].tag = segmentIndex
            item.rowItems[0].isSelected = selectedLocation == .MAP ? true : false
            sectionItems[index.section] = item
            
            //view?.reloadSection(index: index.section)
            view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
        }
        
        
    }
    
    func discountAndDetailsSegmentMapButtonClicked(_ cell: DiscountAndDetailsSegmentTableViewCell){
        selectedLocation = .MAP
        showSelectedTabData(cell: cell)
    }
    
    func discountAndDetailsSegmentListButtonClicked(_ cell: DiscountAndDetailsSegmentTableViewCell){
        selectedLocation = .LIST
        showSelectedTabData(cell: cell)
    }
}

// MARK- OfferQuantityTableViewCellDelegate
extension DiscountAndDetailsPresenter: OfferQuantityTableViewCellDelegate {
    func expandCollapse(index: Int) {
        if selectedRow == IndexPath(row: index, section: 1) {
            if let _ = selectedRow {
                return
            }
        } // already selected
        previousSelectedRow = selectedRow
        selectedRow = IndexPath(row: index, section: 1)
        
        if self.offersDetailResponse?.offerType != .dealVoucher {
            self.updateTitleAndImage(offerDetail: self.offersDetailResponse?.childOffers?[safe: index] ?? OfferDetailsResponse())
        }
        
        if let index = selectedRow {
            self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.isSelected = true
            self.voucherQuantity = (self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.rowValue as? DiscountAndDetailsOfferQuantityTableViewCellModel)?.voucherQuantity
            self.totalPoints = self.offersDetailResponse?.offerType == .dealVoucher ? self.offersDetailResponse?.dealVouchers?[safe: index.row]?.points ?? 0 : self.offersDetailResponse?.childOffers?[safe: index.row]?.pointsValue ?? 0
            
            
            //for saving and validity
            
            let estimatedSaving = self.offersDetailResponse?.offerType == .dealVoucher ? self.offersDetailResponse?.dealVouchers?[safe: index.row]?.estimatedSavings ?? 0 : self.offersDetailResponse?.childOffers?[safe: index.row]?.estimatedSavings ?? 0
            
            let validity = self.offersDetailResponse?.offerType == .dealVoucher ? self.offersDetailResponse?.dealVouchers?[safe: index.row]?.offerValidDate ?? "" : self.offersDetailResponse?.childOffers?[safe: index.row]?.offerValidDate ?? ""
            
            (self.sectionItems.last?.rowItems[safe:0]?.rowValue as? DiscountAndDetailsValidityTableViewCellModel)?.estimatedSavings = "\(AppCommonMethods.getWithAEDValuePrefix(string: estimatedSaving.fractionDigitsRounded(to: 2)))"
            
            (self.sectionItems.last?.rowItems[safe:0]?.rowValue as? DiscountAndDetailsValidityTableViewCellModel)?.validTillDate = validity
            
            self.offersDetailResponse?.estimatedSavings = estimatedSaving
            self.offersDetailResponse?.offerValidDate = validity
            
            
            self.originalPrice = self.offersDetailResponse?.dirhamValue
            self.originalPoints = self.offersDetailResponse?.pointsValue
            
            view?.didSelectRowAt(indexPath: index)
            
            let priceInVat = SwiftUtli.calcaluteAedIncludeVAT(self.offersDetailResponse?.dealVouchers?[safe: index.row]?.discountedPrice.asDoubleOrEmpty() ?? 0.0, vatFactor: self.offersDetailResponse?.vatFactor ?? 0)
            
            let totalAmountToShow = self.offersDetailResponse?.offerType == .dealVoucher ? priceInVat: self.offersDetailResponse?.childOffers?[safe: index.row]?.dirhamValue.asDoubleOrEmpty() ?? 0.0

            let totalAmount = self.offersDetailResponse?.offerType == .dealVoucher ? self.offersDetailResponse?.dealVouchers?[safe: index.row]?.discountedPrice ?? 0.0 : self.offersDetailResponse?.childOffers?[safe: index.row]?.dirhamValue.asDoubleOrEmpty() ?? 0.0
            
            self.totalAmount = totalAmount
            let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: totalAmountToShow.fractionDigitsRounded(to: 2)))"
            
            self.selectedDealVoucher = self.offersDetailResponse?.dealVouchers?[safe: index.row]
            
            if totalAmount > 0 {
                self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: 1, isVatable: self.isVatableOffer)
            }
            
            self.offersDetailResponse?.whatYouGetList = self.offersDetailResponse?.childOffers?[safe:index.row]?.whatYouGetList ?? []
            self.termsAndConditions = self.offersDetailResponse?.childOffers?[safe:index.row]?.termsAndConditions ?? self.termsAndConditions
            self.offersDetailResponse?.merchantLocation = self.offersDetailResponse?.childOffers?[safe:index.row]?.merchantLocation ?? self.merchantLocations
            
            
            if let cells = segmentControlCellForTabs{
                selectedOfferTab = .DETAILS
                self.segmentIndex = 0
                cells.segementControlCategory.setSelectedSegmentIndex(0, animated: true)
                showSelectedTabData(cell: cells)
            }
          
            
            
            
            if let bt = bottomSectionItem,bt.rowItems.count > 0{
                sectionItems.last?.rowItems.removeAll()
                sectionItems.removeLast()
                bt.rowItems.removeAll()
                
            }
            
            generateRowModelsForDealsAndDiscountForSelectedTab()
            
            let index = sectionItems.firstIndex { (model) -> Bool in
                return ((model.rowItems[safe: 0]?.rowValue as? DiscountAndDetailsValidityTableViewCellModel) != nil) ? true : false
            }
            if let indexs = index{
                self.view?.reloadSection(index: indexs)
            }
            
            
            view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
        }
        if let index = previousSelectedRow {
            
            (self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.rowValue as? DiscountAndDetailsOfferQuantityTableViewCellModel)?.voucherQuantity = minimumQuantity
            
//            let priceInVat = SwiftUtli.calcaluteAedIncludeVAT(self.offersDetailResponse?.dealVouchers?[safe: index.row]?.discountedPrice.asDoubleOrEmpty() ?? 0.0, vatFactor: self.offersDetailResponse?.vatFactor ?? 0)

            let amountToAddString = "\(AppCommonMethods.getWithAEDValue(string: "\(self.offersDetailResponse?.childOffers?[safe: index.row]?.dirhamValue.asDoubleOrEmpty() ?? 0.0)"))"
            
            (self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.rowValue as? DiscountAndDetailsOfferQuantityTableViewCellModel)?.cellPrice = amountToAddString
            if self.offersDetailResponse?.offerType == .dealVoucher {
                let strikeOutOriginalPrice = "\(AppCommonMethods.getWithAEDValue(string: self.offersDetailResponse?.dealVouchers?[safe: index.row]?.originalPrice.asDoubleOrEmpty().fractionDigitsRounded(to: 2) ?? ""))"
                
                (self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.rowValue as? DiscountAndDetailsOfferQuantityTableViewCellModel)?.pointsDescription = "\(strikeOutOriginalPrice)"
            } else {
                if let pointsValue = self.offersDetailResponse?.childOffers?[safe: index.row]?.pointsValue, pointsValue > 0 {
                    
                    let  pointsDescription = "\("OrTitle".localizedString.lowercased()) \(pointsValue) \("PTSTitle".localizedString)"
                    (self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.rowValue as? DiscountAndDetailsOfferQuantityTableViewCellModel)?.pointsDescription = pointsDescription
                }
                
            }
            
            self.sectionItems[safe: index.section]?.rowItems[safe: index.row]?.isSelected = false
            view?.didDeSelectRowAt(indexPath: index)
        }
        
        self.isSelectDealVoucher = true
        view?.enableContinueButton(true)
        
    }
    
    func increaseQuantity(withQuantity voucherQuantity: Int, forIndex index: Int,rowModel:DiscountAndDetailsOfferQuantityTableViewCellModel) {
        if voucherQuantity != (self.offersDetailResponse?.offerType == .dealVoucher ? self.offersDetailResponse?.dealVouchers?[safe: index]?.maximumQuantity : self.offersDetailResponse?.childOffers?[safe: index]?.maximumQuantity) {
            var currNumber = voucherQuantity
            if (self.offersDetailResponse?.offerType == .dealVoucher ? (self.offersDetailResponse?.dealVouchers?[safe: index]?.maximumQuantity ?? 0) :(self.offersDetailResponse?.childOffers?[safe: index]?.maximumQuantity ?? 0)) > currNumber {
                currNumber += minimumQuantity
                
                rowModel.voucherQuantity = currNumber
          
                let amount = (self.offersDetailResponse?.offerType == .dealVoucher) ? (self.offersDetailResponse?.dealVouchers?[safe: index]?.discountedPrice.asDoubleOrEmpty() ?? 0.0) : (self.offersDetailResponse?.childOffers?[safe: index]?.dirhamValue.asDoubleOrEmpty() ?? 0.0)
                
                let amountToAddString = "\(AppCommonMethods.getWithAEDValue(string: "\(Double(currNumber) * amount)"))"
                
                if self.offersDetailResponse?.offerType == .dealVoucher {
                    
                    if let originalPrice = self.offersDetailResponse?.dealVouchers?[safe: index]?.originalPrice {
                        let originalPriceString = "\(AppCommonMethods.getWithAEDValue(string: "\(Double(currNumber) * originalPrice)"))"
                        
                        self.totalPoints = (self.offersDetailResponse?.dealVouchers?[safe: index]?.points ?? 0) * currNumber
                        rowModel.pointsDescription = originalPriceString
                    }
                } else {
                    if let pointsValue = self.offersDetailResponse?.childOffers?[safe: index]?.pointsValue {
                        let pointsDescription = "\("OrTitle".localizedString.lowercased()) \(pointsValue * currNumber) \("PTSTitle".localizedString)"
                        //for points
                        self.totalPoints = pointsValue * currNumber
                        rowModel.pointsDescription = pointsDescription
                    }
                }
                
                //for price
                
                rowModel.cellPrice = amountToAddString
                
                self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
                
                var amountForCart: Double?
                
                if self.offersDetailResponse?.offerType == .dealVoucher {
                    let priceInVat = SwiftUtli.calcaluteAedIncludeVAT(self.offersDetailResponse?.dealVouchers?[safe: index]?.discountedPrice.asDoubleOrEmpty() ?? 0.0, vatFactor: self.offersDetailResponse?.vatFactor ?? 0)
                    
                    amountForCart = Double(currNumber) * priceInVat

                    self.totalAmount = Double(currNumber) * (self.offersDetailResponse?.dealVouchers?[safe: index]?.discountedPrice.asDoubleOrEmpty() ?? 0.0)
                } else {
                    self.totalAmount = Double(currNumber) * amount
                }
                
                var amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"

                if let amountForCart = amountForCart {
                    amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: amountForCart.fractionDigitsRounded(to: 2)))"
                }
                
                self.voucherQuantity = currNumber
                
                if totalAmount ?? 0 > 0 {
                    self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: currNumber, isVatable: self.isVatableOffer)
                }
            }
        }
    }
    
    func decreaseQuantity(withQuantity voucherQuantity: Int, forIndex index: Int,rowModel:DiscountAndDetailsOfferQuantityTableViewCellModel) {
        if voucherQuantity != minimumQuantity {
            var currNumber = voucherQuantity
            var numberToDecrease = currNumber
            if ((self.offersDetailResponse?.offerType == .dealVoucher) ? (self.offersDetailResponse?.dealVouchers?[safe: index]?.maximumQuantity ?? 0) : (self.offersDetailResponse?.childOffers?[safe: index]?.maximumQuantity ?? 0)) == currNumber {
                rowModel.voucherQuantity = currNumber - minimumQuantity
                numberToDecrease = currNumber - minimumQuantity
            } else if currNumber == minimumQuantity {
                rowModel.voucherQuantity = minimumQuantity
                numberToDecrease = minimumQuantity
            } else {
                currNumber -= minimumQuantity
                rowModel.voucherQuantity = currNumber
                numberToDecrease = currNumber
            }
            
            let amount = (self.offersDetailResponse?.offerType == .dealVoucher) ? (self.offersDetailResponse?.dealVouchers?[safe: index]?.discountedPrice.asDoubleOrEmpty() ?? 0.0) : (self.offersDetailResponse?.childOffers?[safe: index]?.dirhamValue.asDoubleOrEmpty() ?? 0.0)
            
            let amountToAddString = "\(AppCommonMethods.getWithAEDValue(string: "\(Double(numberToDecrease) * amount)"))"
            
            rowModel.cellPrice = amountToAddString
        
            if self.offersDetailResponse?.offerType == .dealVoucher {
                if let originalPrice = self.offersDetailResponse?.dealVouchers?[safe: index]?.originalPrice {
                    let originalPriceString = "\(AppCommonMethods.getWithAEDValue(string: "\(Double(numberToDecrease) * originalPrice)"))"
                    self.totalPoints = (self.offersDetailResponse?.dealVouchers?[safe: index]?.points ?? 0) * numberToDecrease
                    rowModel.pointsDescription = originalPriceString
                }
            } else {
                if let pointsValue = self.offersDetailResponse?.childOffers?[safe: index]?.pointsValue{
                    let pointsDescription = "\("OrTitle".localizedString.lowercased()) \(pointsValue * numberToDecrease) \("PTSTitle".localizedString)"
                    //for points
                    self.totalPoints  = pointsValue * numberToDecrease
                    rowModel.pointsDescription = pointsDescription
                }
            }
            
            self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
            
            var amountForCart: Double?
            
            if self.offersDetailResponse?.offerType == .dealVoucher {
                let priceInVat = SwiftUtli.calcaluteAedIncludeVAT(self.offersDetailResponse?.dealVouchers?[safe: index]?.discountedPrice.asDoubleOrEmpty() ?? 0.0, vatFactor: self.offersDetailResponse?.vatFactor ?? 0)
                
                amountForCart = Double(numberToDecrease) * priceInVat
                
                self.totalAmount = Double(numberToDecrease) * (self.offersDetailResponse?.dealVouchers?[safe: index]?.discountedPrice.asDoubleOrEmpty() ?? 0.0)
            } else {
                self.totalAmount = Double(numberToDecrease) * amount
            }
            
            
            var amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
            
            if let amountForCart = amountForCart {
                amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: amountForCart.fractionDigitsRounded(to: 2)))"
            }
            
            self.voucherQuantity = numberToDecrease
            
            if totalAmount ?? 0 > 0 {
                self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: numberToDecrease, isVatable: self.isVatableOffer)
            }
        }
    }
    
    func offerQuantityCell(_ cell: DiscountAndDetailsOfferQuantityTableViewCell, didReloadCell isExpanded: Bool) {
        if let index = view?.indexForOfferQuantityCell(cell: cell) {
            (sectionItems[index.section].rowItems[index.row].rowValue as! DiscountAndDetailsOfferQuantityTableViewCellModel).isPriceCellExpanded = isExpanded
            view?.reloadCellAt(index: [index])
        }
    }
    
    
    //MARK: Separater model
    
    func separaterModel() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        
        let spaceCellModel = SpaceCellWithSeperatorModel()
        spaceCellModel.height = 8
        spaceCellModel.isSeperatorNeeded = false
        spaceCellModel.backgroundColorForCell = .appButtonDisabledColor
        spaceCellModel.isComingFromDeals = true
        
        let separaterCell = SpaceCellWithSeperator.rowModel(model: spaceCellModel, tag: 0)
        rowSectionModels.rowItems.append(separaterCell)
        
        return rowSectionModels
    }
    
    
    func separaterModelRow() -> BaseRowModel {
        
        let spaceCellModel = SpaceCellWithSeperatorModel()
        spaceCellModel.height = 8
        spaceCellModel.isSeperatorNeeded = false
        spaceCellModel.backgroundColorForCell = .appButtonDisabledColor
        spaceCellModel.isComingFromDeals = true
        
        let separaterCell = SpaceCellWithSeperator.rowModel(model: spaceCellModel, tag: 0)
        
        return separaterCell
    }
    
}


extension DiscountAndDetailsPresenter: DiscountAndDetailsLocationCellDelegate {
    
    func didSelectContact(selectedIndex: Int) {
        if let merchantLoc = offersDetailResponse?.merchantLocation, merchantLoc.count > 0 {
            if let merchantObj = merchantLoc[safe:selectedIndex], let number = merchantObj.locationPhoneNumber, !number.isEmpty {
                AppCommonMethods.call(phoneNumber: number)
            }
        }
    }
    
    func didSelectMap(selectedIndex: Int) {
        if let merchantLoc = offersDetailResponse?.merchantLocation, merchantLoc.count > 0 {
            if let merchantObj = merchantLoc[safe:selectedIndex], let locLat = merchantObj.locationLatitude, let locLong = merchantObj.locationLongitude {
                AppCommonMethods.openMap(latitude: locLat, longitude: locLong)
            }
        }
    }
}

extension DiscountAndDetailsPresenter {
    
    //From custom object 638 to 669 will be different for each case
    func prepareForHowItWorks() {
        let howViewController = CommonMethods.getViewController(fromStoryboardName: "HowItWorks", andIdentifier: "HowItWorksLottieViewController") as! HowItWorksLottieViewController
        
        let customObject = CommonMethods.loadCustomObject(withKey: "accountType") as? String
        
        if let offerType = self.offersDetailResponse?.offerType {
            switch offerType {
                
            case .discount:
                if (offerType.rawValue.lowercased().contains("etisalat")) {
                    if (customObject.asStringOrEmpty() == "prepaid") {
                        howViewController.arrayTexts = ["EtisalatHowItWorksPage1","EtisalatHowItWorksPagePrePaid", "EtisalatHowItWorksPage3"]
                    } else {
                        howViewController.arrayTexts = ["EtisalatHowItWorksPage1","EtisalatHowItWorksPagePostPaid", "EtisalatHowItWorksPage3"]
                    }
                    howViewController.arrayJsons = ["B1","B2","B3"]
                } else if (self.offersDetailResponse?.cinemaOfferFlag == true) {
                    howViewController.arrayJsons = ["F1","F2"]
                    howViewController.arrayTexts = ["CinemaHowItWorksPage1","CinemaHowItWorksPage2"]
                } else {
                    if (customObject.asStringOrEmpty() == "prepaid") {
                        howViewController.arrayTexts = ["DiscountHowItWorksPage1","EtisalatHowItWorksPagePrePaid","DiscountHowItWorksPage3","DiscountHowItWorksPage4"]
                    } else {
                        howViewController.arrayTexts = ["DiscountHowItWorksPage1","EtisalatHowItWorksPagePostPaid","DiscountHowItWorksPage3","DiscountHowItWorksPage4"]
                    }
                    howViewController.arrayJsons = ["C1","C2","C3","C4"]
                }
            case .dealVoucher:
                
                howViewController.arrayJsons = ["E1","E2","E3","E4","E5"]
                howViewController.arrayTexts = ["DealVoucherHowItWorksPage1","DealVoucherHowItWorksPage2","DealVoucherHowItWorksPage3","DealVoucherHowItWorksPage4","DealVoucherHowItWorksPage5"]
                
            case .etisalat:
                openHowItWorksForEtisalat()
            case .voucher:
                howViewController.arrayJsons = ["D1","D2","D3","D4","D5"]
                howViewController.arrayTexts = ["VoucherHowItWorksPage1","VoucherHowItWorksPage2","VoucherHowItWorksPage3","VoucherHowItWorksPage4","VoucherHowItWorksPage5"]
            }
            
            howViewController.modalPresentationStyle = .overCurrentContext
            
            DispatchQueue.main.async {
                self.router?.presentViewController(vc: howViewController)
            }
        }
    }
    
    func openHowItWorksForEtisalat () {
        
        let aHowItWorksViewController = CommonMethods.getViewController(fromStoryboardName: "Gamification", andIdentifier: "HowItWorksViewController") as! HowItWorksViewController
        
        let customObject = CommonMethods.loadCustomObject(withKey: "accountType") as? String
        
        if let offerType = self.offersDetailResponse?.offerType {
            if (offerType.rawValue.lowercased().contains("etisalat")) {
                if (customObject.asStringOrEmpty() == "prepaid") {
                    aHowItWorksViewController.arrayTexts = ["EtisalatHowItWorksPage1","EtisalatHowItWorksPagePrePaid","EtisalatHowItWorksPage3"]
                } else {
                    aHowItWorksViewController.arrayTexts = ["EtisalatHowItWorksPage1","EtisalatHowItWorksPagePostPaid","EtisalatHowItWorksPage3"]
                }
                aHowItWorksViewController.arrayGifs = ["B1","B2","B3"]
            } else if (self.offersDetailResponse?.cinemaOfferFlag == true) {
                aHowItWorksViewController.arrayGifs = ["F1","F2"]
                aHowItWorksViewController.arrayTexts = ["CinemaHowItWorksPage1","CinemaHowItWorksPage2"]
            } else {
                if (GetEligibilityMatrixResponse.sharedInstance.accountType?.lowercased() == "POSTPAID".lowercased()) {
                    aHowItWorksViewController.arrayTexts = ["DiscountHowItWorksPage1","EtisalatHowItWorksPagePostPaid","DiscountHowItWorksPage3","DiscountHowItWorksPage4"]
                } else {
                    aHowItWorksViewController.arrayTexts = ["DiscountHowItWorksPage1","EtisalatHowItWorksPagePrePaid","DiscountHowItWorksPage3","DiscountHowItWorksPage4"]
                }
                aHowItWorksViewController.arrayGifs = ["C1","C2","C3","C4"]
            }
            
            aHowItWorksViewController.modalPresentationStyle = .overCurrentContext
            
            DispatchQueue.main.async {
                self.router?.presentViewController(vc: aHowItWorksViewController)
            }
        }
    }
}





//MARK: Shahroz Work

extension DiscountAndDetailsPresenter: DiscountAndDetailsAboutTableViewCellDelegate {
    func aboutCell(_ cell: DiscountAndDetailsAboutTableViewCell, didReloadCell isExpanded: Bool) {
        if let index = view?.indexForAboutCell(cell: cell) {
            (sectionItems[index.section].rowItems[index.row].rowValue as! DiscountAndDetailsAboutTableViewCellModel).isDescExpanded = isExpanded
            (sectionItems[index.section].rowItems[index.row].rowValue as! DiscountAndDetailsAboutTableViewCellModel).addReadLess = isExpanded
            view?.reloadCellAt(index: [index])
        }
    }
}

extension DiscountAndDetailsPresenter: OffersCollectionViewCellDelegate {
    func didSelectFavoriteButtonAction(offer: OffersList?, cell: OffersCollectionViewCell, addToFavorite: Bool) {
        if let offer = offer {
            self.nearbyOffer = offer
            if addToFavorite {
                addOfferToFavoriteFromWebService(addToFavorite: addToFavorite, offerId: offer.offerId,isNavBar: false)
            }
            else {
                // show pop up
                let prompetViewController = showPrompetPopUp(title: LanguageManager.sharedInstance().getLocalizedString(forKey: "RemoveItemTitle"), message: LanguageManager.sharedInstance().getLocalizedString(forKey: "RemoveWishlistPopupTitle"),popUpTag: 82)
                prompetViewController.delegate = self
                (UIApplication.shared.delegate as! AppDelegate).tabbarViewController?.present(prompetViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Prompet Delegate

extension DiscountAndDetailsPresenter: PrompetDelegate {
    
    func didDismissPrompetView(_ viewController: UIViewController!, withAction: Bool, popupTag popUpTag: Int) {
        viewController.dismiss(animated: true) {
            if withAction {
                var fromNavBar = false
                if popUpTag == 81 {
                    fromNavBar = true
                }
                if fromNavBar {
                    if let offerId = self.offersDetailResponse?.offerId {
                        self.addOfferToFavoriteFromWebService(addToFavorite: false, offerId: offerId,isNavBar: fromNavBar)
                    }
                } else {
                    if let offerId = self.nearbyOffer?.offerId {
                        self.addOfferToFavoriteFromWebService(addToFavorite: false, offerId: offerId,isNavBar: false)
                    }
                }
                
            }
        }
    }
}

extension DiscountAndDetailsPresenter: OfferSingleQuantityCellDelegate {
    func increaseSingleQuantity(withQuantity voucherQuantity: Int, forIndex index: Int, rowValue:DiscountAndDetailsQuantityTableViewCellModel) {
        if voucherQuantity != self.offersDetailResponse?.maximumQuantity {
            var currNumber = voucherQuantity
            if (self.offersDetailResponse?.maximumQuantity ?? 0) > currNumber {
                currNumber += minimumQuantity
                rowValue.voucherQuantity = currNumber

                self.totalAmount = Double(currNumber) * (self.originalPrice ?? 0.0)
                
                self.totalPoints = (self.originalPoints ?? 0) * currNumber
                
                let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
                
                self.voucherQuantity = currNumber
                
                if totalAmount ?? 0 > 0 {
                    self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: currNumber, isVatable: self.isVatableOffer)
                }
                
                self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
            }
        }
    }
    
    func decreaseSingleQuantity(withQuantity voucherQuantity: Int, forIndex index: Int, rowValue:DiscountAndDetailsQuantityTableViewCellModel) {
        if voucherQuantity != minimumQuantity {
            var currNumber = voucherQuantity
            var numberToDecrease = currNumber
            
            if (self.offersDetailResponse?.maximumQuantity ?? 0) == currNumber {
                rowValue.voucherQuantity = currNumber - minimumQuantity
                numberToDecrease = currNumber - minimumQuantity
            } else if currNumber == minimumQuantity {
                rowValue.voucherQuantity = minimumQuantity
                numberToDecrease = minimumQuantity
            } else {
                currNumber -= minimumQuantity
                rowValue.voucherQuantity = currNumber
                numberToDecrease = currNumber
            }
            
            self.totalAmount = Double(numberToDecrease) * (self.originalPrice ?? 0.0)
            self.totalPoints = (self.originalPoints ?? 0) * numberToDecrease
            
            let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
            
            self.voucherQuantity = numberToDecrease
            
            if totalAmount ?? 0 > 0 {
                self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: numberToDecrease, isVatable: self.isVatableOffer)
            }
            
            self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
            
        }
    }
    
    //Get View for displaying tool tip on HomeCategory cell
    func getViewForToolTip(on tableView: UITableView) -> UIView? {
        for lifeStyleTableViewCell in tableView.visibleCells {
            let indexPath  = tableView.indexPath(for: lifeStyleTableViewCell)
            if let path = indexPath  {
                if let tableCell = tableView.cellForRow(at: path) as? BogoCustomTableCell {
                    return tableCell
                }
            }
        }
        return nil
    }
}


extension DiscountAndDetailsPresenter{
    func detectHtmlLink(str:String){
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: str) else { continue }
            let url = str[range]
            print(url)
            if let url = URL(string: String(url)) {
                UIApplication.shared.open(url)
            }
            break
        }
    }
}

