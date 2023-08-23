//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation

public struct OffersCategoryResponseModel: Codable {
    public let featuredOffers: [OfferDO]?
    public var offers: [OfferDO]? = nil
    public let lifestyleSubscriberFlag: Bool?
    public let offersCount: Int?
    public let listTitle:String?
    public let listSubtitle:String?
    
}
