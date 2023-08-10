//
//  GetOfferDetailsRequest.swift
//  House
//
//  Created by Hanan on 11/11/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesBaseMainRequestManager
import SmilesUtilities

class GetOfferDetailsRequest : Codable {
    
    var offerId : String?
    var latitude : String?
    var longitude : String?
    var additionalInfo = [BaseMainResponseAdditionalInfo]()
    var isGuestUser: Bool?
    
    
    enum UpdateOfferWishlistCodingKeys: String, CodingKey {
        case offerId = "offerId"
        case latitude = "latitude"
        case longitude = "longitude"
        case additionalInfo
        case isGuestUser
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UpdateOfferWishlistCodingKeys.self)
        offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        additionalInfo = try values.decode([BaseMainResponseAdditionalInfo].self, forKey: .additionalInfo)
        isGuestUser = try values.decode(Bool.self, forKey: .isGuestUser)
    }
    
    init() {
        
    }
    
    func asDictionary(dictionary :[String : Any]) -> [String : Any] {
        
        let encoder = DictionaryEncoder()
        guard  let encoded = try? encoder.encode(self) as [String:Any]  else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary:dictionary)
        
    }
}
