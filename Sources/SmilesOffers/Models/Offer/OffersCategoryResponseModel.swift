//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation

public struct OffersCategoryResponseModel: Codable {
    public let featuredOffers: [OfferDO]?
    public let offers: [OfferDO]?
    public let lifestyleSubscriberFlag: Bool?
    public let offersCount: Int?
}
