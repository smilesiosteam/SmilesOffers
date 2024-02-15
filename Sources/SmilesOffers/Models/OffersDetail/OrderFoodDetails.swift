//
//  OrderFoodDetails.swift
//  House
//
//  Created by Shmeel Ahmed on 21/02/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public class OrderFoodDetails: Codable {
    public var title: String?
    public var description: String?
    public var image: String?
    public var restaurantName: String?
    public var menuItemType: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case image
        case restaurantName
        case menuItemType
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        restaurantName = try values.decodeIfPresent(String.self, forKey: .restaurantName)
        menuItemType = try values.decodeIfPresent(String.self, forKey: .menuItemType)
    }
}

