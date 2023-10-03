//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation
import SmilesUtilities
import SmilesSharedModels

public struct OfferDO: Codable {
    public enum RecommendationModelType: String {
        case offer = "offer"
        case food = "Food"
        case none = "none"
    }
    
    public let categoryId: String?
    public let categoryOrder: Int?
    public let amountPerPerson: Double?
    public let restaurantRating: Double?
    public let offerPromotionText: String?
    public var dealType: String? = nil
    public let minimumOrder: Double?
    public let deliveryCharges: Double?
    public let isSubcriber: Bool?
    public let liveTracking: Bool?
    public let cinemaOfferFlag: Bool?
    public let dirhamValue: String?
    public let imageURL: String?
    public let redirectionURL: String?
    public var isWishlisted: Bool?
    public let offerDescription: String?
    public let offerId: String?
    public let offerTitle: String?
    public let offerType: String?
    public let offerTypeAr: String?
    public let originalDirhamValue: String?
    public let originalPointsValue: String?
    public let partnerImage: String?
    public let partnerName: String?
    public let pointsValue: String?
    public let merchantDistance: String?
    public let bonusAmount: String?
    public let voucherPromoText: String?
    public let telcoOfferFlag: Bool?
    public let etisalatOfferCategory: String?
    public let pointsEnabled: Bool?
    public let offerSubTitle: String?
    public let paymentMethods: [PaymentMethod]?
    public var recommendationModelType: OfferDO.RecommendationModelType {
        OfferDO.RecommendationModelType(rawValue: dealType ?? "") ?? .none
    }
    public let smileyPointsUrl: String?
    public var isFeatured = false
    public let recommendationModelEvent: String?

    enum CodingKeys: String, CodingKey {
        case categoryId = "categoryId"
        case categoryOrder = "categoryOrder"
        case amountPerPerson = "amountPerPerson"
        case restaurantRating = "restaurantRating"
        case offerPromotionText = "offerPromotionText"
        case dealType = "recommendationModel"
        case minimumOrder = "minimumOrder"
        case deliveryCharges = "deliveryCharges"
        case isSubcriber = "isSubcriber"
        case liveTracking = "liveTracking"
        case cinemaOfferFlag = "cinemaOfferFlag"
        case dirhamValue = "dirhamValue"
        case imageURL = "imageURL"
        case redirectionURL = "redirectionURL"
        case isWishlisted = "isWishlisted"
        case offerDescription = "offerDescription"
        case offerId = "offerId"
        case offerTitle = "offerTitle"
        case offerType = "offerType"
        case offerTypeAr = "offerTypeAr"
        case originalDirhamValue = "originalDirhamValue"
        case originalPointsValue = "originalPointsValue"
        case partnerImage = "partnerImage"
        case partnerName = "partnerName"
        case pointsValue = "pointsValue"
        case merchantDistance = "merchantDistance"
        case bonusAmount = "bonusAmount"
        case voucherPromoText = "voucherPromoText"
        case telcoOfferFlag = "telcoOfferFlag"
        case etisalatOfferCategory = "etisalatOfferCategory"
        case pointsEnabled = "pointsEnabled"
        case offerSubTitle = "offerSubTitle"
        case paymentMethods = "paymentMethods"
        case smileyPointsUrl = "smileyPointsUrl"
        case recommendationModelEvent
    }
}
