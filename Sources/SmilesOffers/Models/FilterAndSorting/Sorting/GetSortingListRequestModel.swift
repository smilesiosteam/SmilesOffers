//
//  GetSortingListRequestModel.swift
//  House
//
//  Created by Hanan Ahmed on 11/8/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesBaseMainRequestManager

public class GetSortingListRequestModel: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    public var menuItemType: String?
    
    public init(menuItemType: String?) {
        super.init()
        self.menuItemType = menuItemType
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
        case menuItemType
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.menuItemType, forKey: .menuItemType)
    }
}
