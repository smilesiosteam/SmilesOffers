//
//  OfferDetailsResponse.swift
//  House
//
//  Created by Hanan on 11/11/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

class OfferDetailsResponse: BaseMainResponse {
    var internalBaseClassDescription: String?
    var merchantLocation: [MerchantLocationSwift]?
    var offerDescription: String?
    var dirhamValue: Double?
    var categoryId: Int?
    var offerImageUrl: String?
    var offerTitle: String?
    var relatedOffers: [OffersList]?
    var offerType: OfferType?
    var offerId: String?
    var voucherDenominations: [VoucherDenomination]?
    var whatYouGet: String?
    var additionalText: String?
    var termsAndConditions: String?
    var pointsValue: Int?
    var showLocationFlag: Bool?
    var estimatedSavings: Double?
    var offerValidDate: String?
    var partnerName: String?
    var offerTypeAr: String?
    var eligibleFlag: String?
    var ineligibleMsg: String?
    var ineligibleTitle: String?
    var isWishlisted: Bool?
    var partnerPointRate: Double?
    var sharingBonus: Int?
    var voucherBalanceMsg: String?
    var transactionId: String?
    var partnerImageUrl: String?
    var cinemaOfferFlag: Bool?
    var vatFactor: Double?
    var dealVouchers: [DealVoucherSwift]?
    var minVoucherDenomination: VoucherDenomination?
    var maxVoucherDenomination: VoucherDenomination?
    var incrementalDenomination: Int?
    var maximumQuantity: Int?
    var dynamicDenomination: Bool?
    var originalDirhamValue: Double?
    var originalPointsValue: Int?
    var lifestyleSubscriberFlag: Bool?
    var voucherSharingFlag: Bool?
    var voucherPromoText: String?
    var isBirthdayOffer: Bool?
    var isRedeemedOffer: Bool?
    var paymentMethods: [PaymentMethod]?
    var whatYouGetList: [String]?
    var offerPromotionText: String?
    var childOffers: [OfferDetailsResponse]?
    var offerDetailDescription: String?
    
    var categoryOrder : Int?
    var imageURL : String?
    var partnerImage : String?
    var merchantDistance : String?
    var bonusAmount : String?
    var telcoOfferFlag : Bool?
    var etisalatOfferCategory : String?
    var pointsEnabled : Bool?
    var offerSubTitle : String?
    var orderFoodDetails : OrderFoodDetails?
    var isAccountTotalLimit : Bool = true
    var accountTotalLimit : Int?
    
    enum CodingKeys: String, CodingKey {
        case internalBaseClassDescription
        case merchantLocation
        case offerDescription
        case dirhamValue
        case categoryId
        case offerImageUrl
        case offerTitle
        case relatedOffers
        case offerType
        case offerId
        case voucherDenominations
        case whatYouGet
        case additionalText
        case termsAndConditions
        case pointsValue
        case showLocationFlag
        case estimatedSavings
        case offerValidDate
        case partnerName
        case offerTypeAr
        case eligibleFlag
        case ineligibleMsg
        case ineligibleTitle
        case isWishlisted
        case partnerPointRate
        case sharingBonus
        case partnerImageUrl
        case cinemaOfferFlag
        case vatFactor
        case dealVouchers
        case minVoucherDenomination
        case maxVoucherDenomination
        case incrementalDenomination
        case maximumQuantity
        case dynamicDenomination
        case originalDirhamValue
        case originalPointsValue
        case lifestyleSubscriberFlag
        case voucherSharingFlag
        case voucherPromoText
        case isBirthdayOffer
        case isRedeemedOffer
        case paymentMethods
        case whatYouGetList
        case offerPromotionText
        case childOffers
        case offerDetailDescription = "description"
        case categoryOrder
        case imageURL
        case partnerImage
        case merchantDistance
        case bonusAmount
        case telcoOfferFlag
        case etisalatOfferCategory
        case pointsEnabled
        case offerSubTitle
        case orderFoodDetails
        case isAccountTotalLimit
        case accountTotalLimit
    }
    
    override init() { super.init() }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        internalBaseClassDescription = try values.decodeIfPresent(String.self, forKey: .internalBaseClassDescription)
        merchantLocation = try values.decodeIfPresent([MerchantLocationSwift].self, forKey: .merchantLocation)
        offerDescription = try values.decodeIfPresent(String.self, forKey: .offerDescription)
        dirhamValue = try values.decodeIfPresent(Double.self, forKey: .dirhamValue)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        offerImageUrl = try values.decodeIfPresent(String.self, forKey: .offerImageUrl)
        offerTitle = try values.decodeIfPresent(String.self, forKey: .offerTitle)
        relatedOffers = try values.decodeIfPresent([OffersList].self, forKey: .relatedOffers)
        offerType = try values.decodeIfPresent(OfferType.self, forKey: .offerType)
        offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
        voucherDenominations = try values.decodeIfPresent([VoucherDenomination].self, forKey: .voucherDenominations)
        whatYouGet = try values.decodeIfPresent(String.self, forKey: .whatYouGet)
        additionalText = try values.decodeIfPresent(String.self, forKey: .additionalText)
        termsAndConditions = try values.decodeIfPresent(String.self, forKey: .termsAndConditions)
        pointsValue = try values.decodeIfPresent(Int.self, forKey: .pointsValue)
        showLocationFlag = try values.decodeIfPresent(Bool.self, forKey: .showLocationFlag)
        estimatedSavings = try values.decodeIfPresent(Double.self, forKey: .estimatedSavings)
        offerValidDate = try values.decodeIfPresent(String.self, forKey: .offerValidDate)
        partnerName = try values.decodeIfPresent(String.self, forKey: .partnerName)
        offerTypeAr = try values.decodeIfPresent(String.self, forKey: .offerTypeAr)
        eligibleFlag = try values.decodeIfPresent(String.self, forKey: .eligibleFlag)
        ineligibleMsg = try values.decodeIfPresent(String.self, forKey: .ineligibleMsg)
        ineligibleTitle = try values.decodeIfPresent(String.self, forKey: .ineligibleTitle)
        isWishlisted = try values.decodeIfPresent(Bool.self, forKey: .isWishlisted)
        partnerPointRate = try values.decodeIfPresent(Double.self, forKey: .partnerPointRate)
        sharingBonus = try values.decodeIfPresent(Int.self, forKey: .sharingBonus)
        partnerImageUrl = try values.decodeIfPresent(String.self, forKey: .partnerImageUrl)
        cinemaOfferFlag = try values.decodeIfPresent(Bool.self, forKey: .cinemaOfferFlag)
        vatFactor = try values.decodeIfPresent(Double.self, forKey: .vatFactor)
        dealVouchers = try values.decodeIfPresent([DealVoucherSwift].self, forKey: .dealVouchers)
        minVoucherDenomination = try values.decodeIfPresent(VoucherDenomination.self, forKey: .minVoucherDenomination)
        maxVoucherDenomination = try values.decodeIfPresent(VoucherDenomination.self, forKey: .maxVoucherDenomination)
        incrementalDenomination = try values.decodeIfPresent(Int.self, forKey: .incrementalDenomination)
        maximumQuantity = try values.decodeIfPresent(Int.self, forKey: .maximumQuantity)
        dynamicDenomination = try values.decodeIfPresent(Bool.self, forKey: .dynamicDenomination)
        originalDirhamValue = try values.decodeIfPresent(Double.self, forKey: .originalDirhamValue)
        originalPointsValue = try values.decodeIfPresent(Int.self, forKey: .originalPointsValue)
        lifestyleSubscriberFlag = try values.decodeIfPresent(Bool.self, forKey: .lifestyleSubscriberFlag)
        voucherSharingFlag = try values.decodeIfPresent(Bool.self, forKey: .voucherSharingFlag)
        voucherPromoText = try values.decodeIfPresent(String.self, forKey: .voucherPromoText)
        isBirthdayOffer = try values.decodeIfPresent(Bool.self, forKey: .isBirthdayOffer)
        isRedeemedOffer = try values.decodeIfPresent(Bool.self, forKey: .isRedeemedOffer)
        paymentMethods = try values.decodeIfPresent([PaymentMethod].self, forKey: .paymentMethods)
        whatYouGetList = try values.decodeIfPresent([String].self, forKey: .whatYouGetList)
        offerPromotionText = try values.decodeIfPresent(String.self, forKey: .offerPromotionText)
        childOffers = try values.decodeIfPresent([OfferDetailsResponse].self, forKey: .childOffers)
        offerDetailDescription = try values.decodeIfPresent(String.self, forKey: .offerDetailDescription)
        categoryOrder = try values.decodeIfPresent(Int.self, forKey: .categoryOrder)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        partnerImage = try values.decodeIfPresent(String.self, forKey: .partnerImage)
        merchantDistance = try values.decodeIfPresent(String.self, forKey: .merchantDistance)
        bonusAmount = try values.decodeIfPresent(String.self, forKey: .bonusAmount)
        telcoOfferFlag = try values.decodeIfPresent(Bool.self, forKey: .telcoOfferFlag)
        etisalatOfferCategory = try values.decodeIfPresent(String.self, forKey: .etisalatOfferCategory)
        pointsEnabled = try values.decodeIfPresent(Bool.self, forKey: .pointsEnabled)
        offerSubTitle = try values.decodeIfPresent(String.self, forKey: .offerSubTitle)
        orderFoodDetails = try values.decodeIfPresent(OrderFoodDetails.self, forKey: .orderFoodDetails)
        isAccountTotalLimit = try values.decodeIfPresent(Bool.self, forKey: .isAccountTotalLimit) ?? true
        accountTotalLimit = try values.decodeIfPresent(Int.self, forKey: .accountTotalLimit)
        try super.init(from: decoder)
        
    }
    
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: Mirror(reflecting: self).children.map{ ($0.label ?? "", $0.value) })
    }
    func isFree()->Bool{
        pointsValue == 0 && dirhamValue == 0
    }
}

class DealVoucherSwift: Codable {
    var points: Int?
    var discountedPrice: Double?
    var subtitle: String?
    var originalPrice: Double?
    var offerTitle: String?
    var maximumQuantity: Int?
    var offerID: String?
    var subOfferID: String?
    var estimatedSavings: Double?
    var whatYouGet: String?
    var offerValidDate: String?
    var imageUrl: String?
    var termsAndConditions: String?
    var isAccountTotalLimit : Bool = true
    var accountTotalLimit : Int?
    
    enum CodingKeys: String, CodingKey {
        case points
        case discountedPrice
        case subtitle
        case originalPrice
        case offerTitle = "title"
        case maximumQuantity
        case offerID = "offerid"
        case subOfferID = "subOfferid"
        case estimatedSavings
        case whatYouGet
        case offerValidDate
        case imageUrl
        case termsAndConditions
        case isAccountTotalLimit
        case accountTotalLimit
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        points = try values.decodeIfPresent(Int.self, forKey: .points)
        discountedPrice = try values.decodeIfPresent(Double.self, forKey: .discountedPrice)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        originalPrice = try values.decodeIfPresent(Double.self, forKey: .originalPrice)
        offerTitle = try values.decodeIfPresent(String.self, forKey: .offerTitle)
        maximumQuantity = try values.decodeIfPresent(Int.self, forKey: .maximumQuantity)
        offerID = try values.decodeIfPresent(String.self, forKey: .offerID)
        subOfferID = try values.decodeIfPresent(String.self, forKey: .subOfferID)
        estimatedSavings = try values.decodeIfPresent(Double.self, forKey: .estimatedSavings)
        whatYouGet = try values.decodeIfPresent(String.self, forKey: .whatYouGet)
        offerValidDate = try values.decodeIfPresent(String.self, forKey: .offerValidDate)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        termsAndConditions = try values.decodeIfPresent(String.self, forKey: .termsAndConditions)
        isAccountTotalLimit = try values.decodeIfPresent(Bool.self, forKey: .isAccountTotalLimit) ?? true
        accountTotalLimit = try values.decodeIfPresent(Int.self, forKey: .accountTotalLimit)
    }
    func isFree()->Bool{
        points == 0 && discountedPrice == 0 && originalPrice == 0
    }
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
}
