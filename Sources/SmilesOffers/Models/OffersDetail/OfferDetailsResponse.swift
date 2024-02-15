//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

public class OfferDetailsResponse: BaseMainResponse {
    public var internalBaseClassDescription: String?
    public var merchantLocation: [MerchantLocationSwift]?
    public var offerDescription: String?
    public var dirhamValue: Double?
    public var categoryId: Int?
    public var offerImageUrl: String?
    public var offerTitle: String?
    public var relatedOffers: [OffersList]?
    public var offerType: OfferType?
    public var offerId: String?
    public var voucherDenominations: [VoucherDenomination]?
    public var whatYouGet: String?
    public var additionalText: String?
    public var termsAndConditions: String?
    public var pointsValue: Int?
    public var showLocationFlag: Bool?
    public var estimatedSavings: Double?
    public var offerValidDate: String?
    public var partnerName: String?
    public var offerTypeAr: String?
    public var eligibleFlag: String?
    public var ineligibleMsg: String?
    public var ineligibleTitle: String?
    public var isWishlisted: Bool?
    public var partnerPointRate: Double?
    public var sharingBonus: Int?
    public var voucherBalanceMsg: String?
    public var transactionId: String?
    public var partnerImageUrl: String?
    public var cinemaOfferFlag: Bool?
    public var vatFactor: Double?
    public var dealVouchers: [DealVoucherSwift]?
    public var minVoucherDenomination: VoucherDenomination?
    public var maxVoucherDenomination: VoucherDenomination?
    public var incrementalDenomination: Int?
    public var maximumQuantity: Int?
    public var dynamicDenomination: Bool?
    public var originalDirhamValue: Double?
    public var originalPointsValue: Int?
    public var lifestyleSubscriberFlag: Bool?
    public var voucherSharingFlag: Bool?
    public var voucherPromoText: String?
    public var isBirthdayOffer: Bool?
    public var isRedeemedOffer: Bool?
    public var paymentMethods: [PaymentMethod]?
    public var whatYouGetList: [String]?
    public var offerPromotionText: String?
    public var childOffers: [OfferDetailsResponse]?
    public var offerDetailDescription: String?
    
    public var categoryOrder : Int?
    public var imageURL : String?
    public var partnerImage : String?
    public var merchantDistance : String?
    public var bonusAmount : String?
    public var telcoOfferFlag : Bool?
    public var etisalatOfferCategory : String?
    public var pointsEnabled : Bool?
    public var offerSubTitle : String?
    public var orderFoodDetails : OrderFoodDetails?
    public var isAccountTotalLimit : Bool = true
    public var accountTotalLimit : Int?
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
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
    
    // MARK: - Initialization
    
    override public init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // Decode properties
    }
    
    // MARK: - Additional methods/functions
    
    public func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: Mirror(reflecting: self).children.map{ ($0.label ?? "", $0.value) })
    }
    
    public func isFree() -> Bool {
        return pointsValue == 0 && dirhamValue == 0
    }
}


public class DealVoucherSwift: Codable {
    public var points: Int?
    public var discountedPrice: Double?
    public var subtitle: String?
    public var originalPrice: Double?
    public var offerTitle: String?
    public var maximumQuantity: Int?
    public var offerID: String?
    public var subOfferID: String?
    public var estimatedSavings: Double?
    public var whatYouGet: String?
    public var offerValidDate: String?
    public var imageUrl: String?
    public var termsAndConditions: String?
    public var isAccountTotalLimit : Bool = true
    public var accountTotalLimit : Int?
    
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
    
    public required init(from decoder: Decoder) throws {
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
    
    public func isFree() -> Bool {
        return points == 0 && discountedPrice == 0 && originalPrice == 0
    }
    
    public func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
}


