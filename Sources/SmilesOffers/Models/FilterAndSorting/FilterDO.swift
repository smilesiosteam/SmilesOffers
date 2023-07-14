//
//  FilterDO.swift
//  House
//
//  Created by Hannan on 21/09/2020.
//  Copyright © 2020 Ahmed samir ali. All rights reserved.
//

import UIKit

public class FilterDO: Codable {
    
    public var name: String?
    public var filterKey: String?
    public var filterValue: String?
    public var parentTitle: String?
    public var isSelected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name
        case filterKey
        case filterValue
        case parentTitle
    }
    
    public init() {}
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        filterKey = try values.decodeIfPresent(String.self, forKey: .filterKey)
        filterValue = try values.decodeIfPresent(String.self, forKey: .filterValue)
        parentTitle = try values.decodeIfPresent(String.self, forKey: .parentTitle)
    }
}
    
