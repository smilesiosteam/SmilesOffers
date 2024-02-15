//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//

import Foundation
import SmilesBaseMainRequestManager
import SmilesUtilities

public class GetOfferDetailsRequest : Codable {
    
   public var offerId : String?
   public var latitude : String?
   public var longitude : String?
   public var additionalInfo = [BaseMainResponseAdditionalInfo]()
   public var isGuestUser: Bool?
    
    
   public enum UpdateOfferWishlistCodingKeys: String, CodingKey {
        case offerId = "offerId"
        case latitude = "latitude"
        case longitude = "longitude"
        case additionalInfo
        case isGuestUser
    }
    
   public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UpdateOfferWishlistCodingKeys.self)
        offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        additionalInfo = try values.decode([BaseMainResponseAdditionalInfo].self, forKey: .additionalInfo)
        isGuestUser = try values.decode(Bool.self, forKey: .isGuestUser)
    }
    
   public init() {
        
    }
    
   public func asDictionary(dictionary :[String : Any]) -> [String : Any] {
        
        let encoder = DictionaryEncoder()
        guard  let encoded = try? encoder.encode(self) as [String:Any]  else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary:dictionary)
        
    }
}

