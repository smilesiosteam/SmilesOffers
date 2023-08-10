//
//  VoucherDenomination.swift
//  House
//
//  Created by Hanan on 11/11/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation

class VoucherDenomination: Codable {
    var denominationPoint: Int?
    var denominationAED: Int?

    enum CodingKeys: String, CodingKey {
        case denominationPoint
        case denominationAED
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        denominationPoint = try values.decodeIfPresent(Int.self, forKey: .denominationPoint)
        denominationAED = try values.decodeIfPresent(Int.self, forKey: .denominationAED)
    }
}
