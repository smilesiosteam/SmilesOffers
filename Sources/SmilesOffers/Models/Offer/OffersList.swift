//
//  NearbyOffersResponseOffer.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 1, 2019

import Foundation
import SmilesUtilities

public class OffersList : Codable {
    
   public var categoryId : String?
   public var categoryOrder : Int?
   public var cinemaOfferFlag : Bool?
   public var dirhamValue : String?
   public var imageURL : String?
   public var isWishlisted : Bool?
   public var merchantDistance : String?
   public var offerDescription : String?
   public var offerId : String?
   public var offerTitle : String?
   public var offerType : String?
   public var offerTypeAr : String?
   public var partnerImage : String?
   public var partnerName : String?
   public var pointsValue : String?
   public var originalPointsValue : String?
   public var originalDirhamValue : String?
   public var voucherPromoText : String?
   public var isBirthdayOffer : Bool?
   public var isRedeemedOffer : Bool?
   public var birthdayTxt : String?
   public var redeemedTxt : String?
   public var recommendationModelEvent: String?
    
   public enum CodingKeys: String, CodingKey {
        case categoryId = "categoryId"
        case categoryOrder = "categoryOrder"
        case cinemaOfferFlag = "cinemaOfferFlag"
        case dirhamValue = "dirhamValue"
        case imageURL = "imageURL"
        case isWishlisted = "isWishlisted"
        case merchantDistance = "merchantDistance"
        case offerDescription = "offerDescription"
        case offerId = "offerId"
        case offerTitle = "offerTitle"
        case offerType = "offerType"
        case offerTypeAr = "offerTypeAr"
        case partnerImage = "partnerImage"
        case partnerName = "partnerName"
        case pointsValue = "pointsValue"
        case originalPointsValue = "originalPointsValue"
        case originalDirhamValue = "originalDirhamValue"
        case voucherPromoText = "voucherPromoText"
        case isBirthdayOffer = "isBirthdayOffer"
        case isRedeemedOffer = "isRedeemedOffer"
        case birthdayTxt = "birthdayTxt"
        case redeemedTxt = "redeemedTxt"
        case recommendationModelEvent
    }
    
   public required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
            categoryOrder = try values.decodeIfPresent(Int.self, forKey: .categoryOrder)
            cinemaOfferFlag = try values.decodeIfPresent(Bool.self, forKey: .cinemaOfferFlag)
            dirhamValue = try values.decodeIfPresent(String.self, forKey: .dirhamValue)
            imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
            isWishlisted = try values.decodeIfPresent(Bool.self, forKey: .isWishlisted)
            merchantDistance = try values.decodeIfPresent(String.self, forKey: .merchantDistance)
            offerDescription = try values.decodeIfPresent(String.self, forKey: .offerDescription)
            offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
            offerTitle = try values.decodeIfPresent(String.self, forKey: .offerTitle)
            offerType = try values.decodeIfPresent(String.self, forKey: .offerType)
            offerTypeAr = try values.decodeIfPresent(String.self, forKey: .offerTypeAr)
            partnerImage = try values.decodeIfPresent(String.self, forKey: .partnerImage)
            partnerName = try values.decodeIfPresent(String.self, forKey: .partnerName)
            pointsValue = try values.decodeIfPresent(String.self, forKey: .pointsValue)
            originalPointsValue = try values.decodeIfPresent(String.self, forKey: .originalPointsValue)
            originalDirhamValue = try values.decodeIfPresent(String.self, forKey: .originalDirhamValue)
            voucherPromoText = try values.decodeIfPresent(String.self, forKey: .voucherPromoText)
            isBirthdayOffer = try values.decodeIfPresent(Bool.self, forKey: .isBirthdayOffer)
            isRedeemedOffer = try values.decodeIfPresent(Bool.self, forKey: .isRedeemedOffer)
            birthdayTxt = try values.decodeIfPresent(String.self, forKey: .birthdayTxt)
            redeemedTxt = try values.decodeIfPresent(String.self, forKey: .redeemedTxt)
            recommendationModelEvent = try values.decodeIfPresent(String.self, forKey: .recommendationModelEvent)
            
        } catch let ex {
            print(ex.localizedDescription)
        }
    }
    
   public init() {
        categoryId = ""
        categoryOrder = 0
        cinemaOfferFlag = false
        dirhamValue = ""
        imageURL = ""
        isWishlisted = false
        merchantDistance = ""
        offerDescription = ""
        offerId = ""
        offerTitle = ""
        offerType = ""
        offerTypeAr = ""
        partnerImage = ""
        partnerName = ""
        pointsValue = ""
        originalPointsValue = ""
        originalDirhamValue = ""
        voucherPromoText = ""
        isRedeemedOffer = false
        isBirthdayOffer = false
        redeemedTxt = ""
        birthdayTxt = ""
        recommendationModelEvent = ""
    }
    
    public func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
    
}
