//
//  MerchantLocationSwift.swift
//  House
//
//  Created by Hanan on 11/11/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation

public class MerchantLocationSwift: Codable {
   public var locationName: String?
   public var locationAddress: String?
   public var locationLatitude: Double?
   public var locationLongitude: Double?
   public var distance: Double?
   public var locationPhoneNumber: String?

   public enum CodingKeys: String, CodingKey {
        case locationName
        case locationAddress
        case locationLatitude
        case locationLongitude
        case distance
        case locationPhoneNumber
    }

   public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        locationName = try values.decodeIfPresent(String.self, forKey: .locationName)
        locationAddress = try values.decodeIfPresent(String.self, forKey: .locationAddress)
        locationLatitude = try values.decodeIfPresent(Double.self, forKey: .locationLatitude)
        locationLongitude = try values.decodeIfPresent(Double.self, forKey: .locationLongitude)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        locationPhoneNumber = try values.decodeIfPresent(String.self, forKey: .locationPhoneNumber)
    }
}
