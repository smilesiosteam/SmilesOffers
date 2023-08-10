//
//  OrderFoodDetails.swift
//  House
//
//  Created by Shmeel Ahmed on 21/02/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
class OrderFoodDetails : Codable {
    var title : String?
    var description : String?
    var image : String?
    var restaurantName : String?
    var menuItemType : String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case image
        case restaurantName
        case menuItemType
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        restaurantName = try values.decodeIfPresent(String.self, forKey: .restaurantName)
        menuItemType = try values.decodeIfPresent(String.self, forKey: .menuItemType)
    }
}
