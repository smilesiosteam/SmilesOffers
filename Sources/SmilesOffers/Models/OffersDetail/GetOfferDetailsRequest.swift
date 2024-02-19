//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//

import Foundation
import SmilesBaseMainRequestManager
import SmilesUtilities

public class GetOfferDetailsRequest : SmilesBaseMainRequest {
    
   public var offerId : String?
   public var latitude : String?
   public var longitude : String?
   public var isGuestUser: Bool?
    
    
   public enum CodingKeys: String, CodingKey {
        case offerId = "offerId"
        case latitude = "latitude"
        case longitude = "longitude"
        case isGuestUser
    }
    
    public init(offerId : String? = nil,latitude: String? = nil,longitude : String? = nil) {
        super.init()
        self.offerId = offerId
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
//   public required init(from decoder: Decoder) throws {
//       super.init()
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
//        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
//        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
//        isGuestUser = try values.decode(Bool.self, forKey: .isGuestUser)
//    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.offerId, forKey: .offerId)
        try container.encodeIfPresent(self.latitude, forKey: .latitude)
        try container.encodeIfPresent(self.longitude, forKey: .longitude)
        
    }
    
    
    
   public func asDictionary(dictionary :[String : Any]) -> [String : Any] {
        
        let encoder = DictionaryEncoder()
        guard  let encoded = try? encoder.encode(self) as [String:Any]  else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary:dictionary)
        
    }
}

