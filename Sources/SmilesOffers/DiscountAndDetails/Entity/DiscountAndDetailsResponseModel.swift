//
//  DiscountAndDetailsResponseModel.swift
//  House
//
//  Created by Shahroze Zaheer on 10/19/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import NetworkingLayer

class DiscountAndDetailsResponseModel: BaseMainResponse {
    // MARK: - Model Keys
    
    enum CodingKeys: String, CodingKey{
        case value1
        case value2
    }
    
    // MARK: - Model Variables
    
    var value1: String?
    var value2: String?
    
    // MARK: - Model mapping
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value1 = try values.decodeIfPresent(String.self, forKey: .value1)
        value2 = try values.decodeIfPresent(String.self, forKey: .value2)
        try super.init(from: decoder)
    }
}
